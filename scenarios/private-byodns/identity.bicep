@description('Indicates whether to create a new user-assigned managed identity or use an existing one.')
param createNewIdentity bool = false

@description('The name of the user-assigned managed identity.')
param identityName string

@description('The resource group name of the user-assigned managed identity. If creating a new identity, this is the resource group where it will be created.')
param identityResourceGroupName string = resourceGroup().name

@description('The subscription ID of the user-assigned managed identity. If creating a new identity, this is the subscription where it will be created.')
param identitySubscriptionId string = subscription().subscriptionId

resource aksIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = if (createNewIdentity) {
  name: identityName
  location: resourceGroup().location
}

resource existingAksIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!createNewIdentity) {
  name: identityName
  scope: resourceGroup(identitySubscriptionId, identityResourceGroupName)
}

// Output the identity ID
output identityId string = createNewIdentity ? aksIdentity.id : existingAksIdentity.id
output principalId string = createNewIdentity ? aksIdentity.properties.principalId: existingAksIdentity.properties.principalId
