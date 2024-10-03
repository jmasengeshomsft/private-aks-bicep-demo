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

//api Server Access Profile
@description('Whether you need to use a pre-existing dns zone')
param byoDns bool = true
@description('The resource group for the existing private dns zone')
param dnsResourceGroupName string = 'aks-playground-global-rg'
@description('The existing private dns zone')
param privateDNSZoneAKSName string = ''
@description('Whether you need to vnet integration to access the API Sever: Preview')
param enableVnetIntegration bool = false
@description('The subnet that should be delated to AKS for vnet integration')
param apiServerSubnetName string =''


@secure()
param aksadminaccessprincipalId string
param kubernetesVersion string
param location string = resourceGroup().location
param availabilityZones array = [
  '1'
  '2'
  '3'
]

@description('The node pool settings for the cluster user nodepool.')
param userNodePoolSettings object

@description('The node pool settings for the cluster system node pool.')
param systemNodePoolSettings object

param existingIdentityName string = ''
param identityResourceGroupName string = ''
param identitySubscriptionId string = ''




var suffix = uniqueString(resourceGroup().id)
var clusterName = 'aks-${suffix}-cluster'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroupName
  scope: subscription()
}

// //AKS Identity
resource aksIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: existingIdentityName
  scope: resourceGroup(identitySubscriptionId, identityResourceGroupName)
}

resource pvtdnsAKSZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  scope: resourceGroup(dnsResourceGroupName)
  name: privateDNSZoneAKSName
}


// // //aks vnet write role
// module vnetContrib '../../modules/dnsContributorRole.bicep' = {
//   scope: resourceGroup(vnetResourceGroupName)
//   name: 'aksPvtDNSContrib'
//   params: {
//     principalId: aksIdentity.properties.principalId
//     roleGuid: 'b12aa53e-6015-4669-85d0-8515ebb3ae7f' //Private DNS Zone Contributor
//     pvtdnsAKSZoneName: privateDNSZoneAKSName
//   }
// }

// module aksPvtDNSContrib '../../modules/vnetContributorRole.bicep' = {
//   scope: resourceGroup(dnsResourceGroupName)
//   name: 'vnetContri'
//   params: {
//     principalId: aksIdentity.properties.principalId
//     roleGuid: '4d97b98b-1d4f-4787-a291-c67834d212e7' //vnet Contributor
//     vnetName: vnetName
//   }
// }

//get the subnet Id using the vnetname and subnet name
var aksSubnetId = resourceId(resourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

var apiServerSubnetId = resourceId(resourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, apiServerSubnetName)


resource akslaworkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
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
    logworkspaceid: akslaworkspace.id
    subnetId: aksSubnetId
    minNodeCount: systemNodePoolSettings.minCount
    maxNodeCount: systemNodePoolSettings.maxCount
    nodeCount: systemNodePoolSettings.nodeCount
    systemNodePoolVMSize: systemNodePoolSettings.poolVMSize
    // identity: {
    //   type: 'SystemAssigned'
    // }
    identity: {
      '${aksIdentity.id}': {}
    }

  
   byoDns: byoDns
   privateDNSZone: pvtdnsAKSZone.id
   enableVnetIntegration: enableVnetIntegration
   //apiServerSubnetId: apiServerSubnetId
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
