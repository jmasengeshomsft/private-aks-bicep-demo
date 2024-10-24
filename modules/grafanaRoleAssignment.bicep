param principalId string
param roleGuid string
param amwName string
param grafanaName string

resource azureMonitorWorkspace 'microsoft.monitor/accounts@2023-04-03' existing = {
  name: amwName
}

resource role_assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, principalId, roleGuid, grafanaName)
  properties: {
    principalId: principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleGuid)
  }
  scope: azureMonitorWorkspace
}
