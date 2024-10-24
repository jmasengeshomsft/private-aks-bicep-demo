targetScope = 'resourceGroup'

param resourceGroupName string
param tags object

//monitoring
param lawResourceGroupName string = ''
param lawName string

//Networking
param vnetResourceGroupName string 
param vnetName string
param subnetName string
@allowed([
  'azure'
  'kubenet'
])
param networkPlugin string = 'azure'
param networkPluginMode string
param networkPolicy string
param outboundType string
param serviceCidr string = '10.240.0.0/16'
param dnsServiceIP string = '10.240.0.10'
param skuTier string
param podCidr string
param enablePrivateCluster bool = false


@secure()
param aksadminaccessprincipalId string
param kubernetesVersion string
param location string = resourceGroup().location
param availabilityZones array = [
  '1'
  '2'
  '3'
]

// @description('The node pool settings for the cluster user nodepool.')
param userNodePoolSettings object

@description('The node pool settings for the cluster system node pool.')
param systemNodePoolSettings object

//Monitoring
param enablePrometheusGrafana bool = true
param enablePrometheusRecommendedAlerts  bool = true
param grafanaName string 
param grafanaResourceGroupName string 
param prometheusResourceName string 
param prometheusResourceGroupName string 

var suffix = uniqueString(resourceGroup().id)
var clusterName = 'aks-${suffix}-mon'

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: resourceGroupName
  scope: subscription()
}

//get the subnet Id using the vnetname and subnet name
var aksSubnetId = resourceId(vnetResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

resource akslaworkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  scope: resourceGroup(lawResourceGroupName)
  name: lawName
}

module aksCluster '../../modules/aks/aks.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'aksClustereastus'
  params: {
    enableAutoScaling: true
    availabilityZones: availabilityZones
    location: location
    aadGroupdIds: [
      aksadminaccessprincipalId
    ]
    clusterName: clusterName
    kubernetesVersion: kubernetesVersion
    networkPlugin: networkPlugin
    networkPluginMode: networkPluginMode
    networkPolicy: networkPolicy
    outboundType: outboundType
    serviceCidr: serviceCidr
    dnsServiceIP: dnsServiceIP
    podCidr: podCidr
    enablePrivateCluster: enablePrivateCluster
    logworkspaceid: akslaworkspace.id
    subnetId: aksSubnetId
    minNodeCount: systemNodePoolSettings.minCount
    maxNodeCount: systemNodePoolSettings.maxCount
    nodeCount: systemNodePoolSettings.nodeCount
    systemNodePoolVMSize: systemNodePoolSettings.poolVMSize
    identity: {
      type: 'SystemAssigned'
    }
   skuTier: skuTier
   tags: tags
  }
}

//add default worker pool
module aksWorkerPool '../../modules/aks/aksNodePool.bicep' = {
  name: 'aksWorkerPool'
  scope: resourceGroup(rg.name)
  params: {
    clusterName: clusterName
    aksVersion: kubernetesVersion
    poolVMSize: userNodePoolSettings.poolVMSize
    aksSubnetId: aksSubnetId
    poolName: 'workload'
    poolMode: 'User'
    nodeCount: userNodePoolSettings.nodeCount
    minNodeCount: userNodePoolSettings.minCount
    maxNodeCount: userNodePoolSettings.maxCount
    maxPods: 110
    enableAutoScaling: true
    enableEncryptionAtHost: false
    poolOsSku: 'Ubuntu'
    poolOsType: 'Linux'
    poolOsDiskType: 'Managed'
    availabilityZones: availabilityZones
    tags: tags
  } 
  dependsOn: [
    aksCluster
  ]
}

module aksPrometheusCollector '../../modules/aks/aks-prometheus-collector/main.bicep' =  if (enablePrometheusGrafana) {
  name: 'aksPrometheusCollector'
  scope: resourceGroup(rg.name)
  params: {
    clusterName: clusterName
    grafanaName: grafanaName
    grafanaResourceGroupName: grafanaResourceGroupName
    amwName: prometheusResourceName
    amwResourceGroupName: prometheusResourceGroupName
    location: location
    adminGroupObjectId: aksadminaccessprincipalId
    alertActionGroupName: 'AKS-PLYGRND-ALERTS'
    enablePrometheusRecommendedAlerts: enablePrometheusRecommendedAlerts
  }
  dependsOn: [
    aksCluster
  ]
}




//Enable Recommended alerts


//sample metric alert
