param principalId string
param roleGuid string
param grafanaName string

resource grafanaResource 'Microsoft.Dashboard/grafana@2023-09-01' existing = {
  name: grafanaName
}

resource role_assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, principalId, roleGuid, grafanaName)
  properties: {
    principalId: principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleGuid)
  }
  scope: grafanaResource
}
