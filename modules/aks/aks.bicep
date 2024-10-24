param clusterName string
param logworkspaceid string
param subnetId string
param kubernetesVersion string
param location string = resourceGroup().location
param availabilityZones array = [
  '1'
  '2'
  '3'
]
param identity object = {}
param privateDNSZone string = 'system'
param byoDns bool = false
param enablePrivateCluster bool = true

param maxNodeCount int
param minNodeCount int
param nodeCount int
param systemNodePoolVMSize string
param aadGroupdIds array 
param enableAutoScaling bool

@allowed([
  'azure'
  'kubenet'
])
param networkPlugin string = 'azure'
param networkPluginMode string
param networkPolicy string 
param outboundType string
param serviceCidr string
param dnsServiceIP string
param skuTier string
param podCidr string


param tags object

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-06-02-preview' = {
  name: clusterName
  location: location

  identity: byoDns ? {
    type: 'UserAssigned'
    userAssignedIdentities: identity
  } : {
    type: 'SystemAssigned'
  }

  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: '${clusterName}aks'
    agentPoolProfiles: [
      {
        enableAutoScaling: enableAutoScaling
        name: 'defaultpool'
        availabilityZones: !empty(availabilityZones) ? availabilityZones : null
        mode: 'System'
        enableEncryptionAtHost: false
        count: nodeCount
        minCount: enableAutoScaling ? minNodeCount : null
        maxCount: enableAutoScaling ? maxNodeCount : null
        vmSize: systemNodePoolVMSize
        osDiskSizeGB: 30
        type: 'VirtualMachineScaleSets'
        vnetSubnetID: subnetId
        orchestratorVersion: kubernetesVersion
      }
    ]

    networkProfile: networkPlugin == 'azure' ? {
      networkPlugin: 'azure'
      networkPluginMode: networkPluginMode
      outboundType: outboundType
      dnsServiceIP: dnsServiceIP
      serviceCidr: serviceCidr
      networkPolicy: networkPolicy
      podCidr: podCidr
    }:{
      networkPlugin: 'kubenet'
      outboundType: outboundType
      dnsServiceIP: dnsServiceIP
      serviceCidr: serviceCidr
      networkPolicy: networkPolicy
      podCidr: '10.248.0.0/16'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: enablePrivateCluster
      enablePrivateClusterPublicFQDN: false
      privateDNSZone: enablePrivateCluster ?  privateDNSZone : null
    }
    enableRBAC: true
    // fqdnSubdomain: 'dev'
    aadProfile: {
      adminGroupObjectIDs: aadGroupdIds
      enableAzureRBAC: true
      managed: true
      tenantID: subscription().tenantId
    }
    securityProfile: {
      defender: {
        logAnalyticsWorkspaceResourceId: logworkspaceid
        securityMonitoring: {
          enabled: true
        }
      }
      workloadIdentity: {
        enabled: true
      }
    }
    addonProfiles: {
      omsagent: {
        config: {
          logAnalyticsWorkspaceResourceID: logworkspaceid
        }
        enabled: true
      }
      azurepolicy: {
        enabled: true
      }
      azureKeyvaultSecretsProvider: {
        enabled: true
      }
    }
    oidcIssuerProfile: {
      enabled: true
    }
  }
  tags: tags
  sku: {
    name: 'Base'
    tier: skuTier
  }
}

#disable-next-line use-recent-api-versions // Latest stable is too old
resource aksDiatgnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${clusterName}-DiagnosticSettings'
  scope: aksCluster
  properties: {
    logs: [
      {
        category: 'guard'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: true
        }
      }
      {
        category: 'cluster-autoscaler'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: true
        }
      }
      {
        category: 'kube-audit'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: true
        }
      }
      {
        category: 'kube-apiserver'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: true
        }
      }
      {
        category: 'kube-audit-admin'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: true
        }
      }

    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: true
        }
      }
    ]
    workspaceId: logworkspaceid
  }
}

output kubeletIdentity string = aksCluster.properties.identityProfile.kubeletidentity.objectId
output keyvaultaddonIdentity string = aksCluster.properties.addonProfiles.azureKeyvaultSecretsProvider.identity.objectId
