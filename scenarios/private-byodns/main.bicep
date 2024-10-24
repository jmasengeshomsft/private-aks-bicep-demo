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
param dnsResourceGroupName string
@description('The existing private dns zone')
param privateDNSZoneAKSName string


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

param identityName string = ''
param identityResourceGroupName string = ''
param identitySubscriptionId string = ''
param createNewIdentity bool = true
param nvaNextHopIAddressIp string 


var suffix = uniqueString(resourceGroup().id)
var clusterName = 'aks-${suffix}-dns-byo'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroupName
  scope: subscription()
}


// Networking
module networking 'networking.bicep' = {
  name: 'networking'
  scope: resourceGroup(vnetResourceGroupName)
  params: {
    routeTableName: '${clusterName}-udr'
    location: location
    vnetName: vnetName
    subnetName: 'aks-subnet-2'
    addressPrefix: '10.128.1.160/27'
    nvaNextHopIAddressIp: nvaNextHopIAddressIp
    tags: tags
  }
}

// //AKS Identity
module aksIdentity 'identity.bicep' = {
  name: 'aksIdentity'
  scope: resourceGroup(identitySubscriptionId, identityResourceGroupName)
  params: {
    createNewIdentity: createNewIdentity
    identityName: identityName
    identityResourceGroupName: identityResourceGroupName
    identitySubscriptionId: identitySubscriptionId
  }
}
//Add networking components here


resource pvtdnsAKSZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  scope: resourceGroup(dnsResourceGroupName)
  name: privateDNSZoneAKSName
}


// // //aks vnet write role
module aksPvtDNSContrib '../../modules/dnsContributorRole.bicep' = if(createNewIdentity) {
  scope: resourceGroup(dnsResourceGroupName)
  name: 'aksPvtDNSContrib'
  params: {
    principalId: aksIdentity.outputs.principalId
    roleGuid: 'b12aa53e-6015-4669-85d0-8515ebb3ae7f' //Private DNS Zone Contributor
    pvtdnsAKSZoneName: privateDNSZoneAKSName
  }
}

module vnetConrib '../../modules/vnetContributorRole.bicep' = if(createNewIdentity) {
  scope: resourceGroup(vnetResourceGroupName)
  name: 'vnetContrib'
  params: {
    principalId: aksIdentity.outputs.principalId
    roleGuid: '4d97b98b-1d4f-4787-a291-c67834d212e7' //vnet Contributor
    vnetName: vnetName
  }
}

//get the subnet Id using the vnetname and subnet name
var aksSubnetId = resourceId(vnetResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

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
    enablePrivateCluster: true
    logworkspaceid: akslaworkspace.id
    subnetId: networking.outputs.subnetId
    minNodeCount: systemNodePoolSettings.minCount
    maxNodeCount: systemNodePoolSettings.maxCount
    nodeCount: systemNodePoolSettings.nodeCount
    systemNodePoolVMSize: systemNodePoolSettings.poolVMSize
    identity: {
      '${aksIdentity.outputs.identityId}': {}
    }
   byoDns: byoDns
   privateDNSZone: pvtdnsAKSZone.id
   //sku configuration
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
