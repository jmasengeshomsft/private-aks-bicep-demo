param clusterName string
param aksVersion string
param poolVMSize string
param aksSubnetId string
param poolName string
param poolMode string = 'User'
param minNodeCount int = 2
param maxNodeCount int = 10
param nodeCount int 
param maxPods int = 110
param enableAutoScaling bool = true
param enableEncryptionAtHost bool = false
param poolOsSku string = 'Ubuntu'
param poolOsType string = 'Linux'
param poolOsDiskType string = 'Managed'
param availabilityZones array = [
  '1'
  '2'
  '3'
]
param tags object

//load kubernetes cluster 
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-05-01' existing = {
  name: clusterName
}


resource aksUserCluster 'Microsoft.ContainerService/managedClusters/agentPools@2023-05-01' = {
  name: poolName
  parent: aksCluster
  properties: {
    availabilityZones: availabilityZones
    enableAutoScaling: enableAutoScaling
    enableEncryptionAtHost: enableEncryptionAtHost
    enableNodePublicIP: false
    enableUltraSSD: false
    count: nodeCount
    maxCount: maxNodeCount
    minCount: minNodeCount
    maxPods: maxPods
    mode: poolMode
    nodeLabels: {}
    nodeTaints: [
    ]
    orchestratorVersion: aksVersion
    osDiskType: poolOsDiskType
    osSKU: poolOsSku
    osType: poolOsType
    tags: tags
    type: 'VirtualMachineScaleSets'
    vmSize: poolVMSize 
    vnetSubnetID: aksSubnetId
  }
}
