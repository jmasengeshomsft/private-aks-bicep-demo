param grafanaPrincipalId string

@description('A new GUID used to identify the role assignment for Grafana')
param roleNameGuid string
param amwName string

resource azureMonitorWorkspace 'microsoft.monitor/accounts@2023-04-03' existing = {
  name: amwName
}

resource roleAssignmentLocal 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleNameGuid
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'b0d8363b-8ddd-447d-831f-62ca05bff136')
    principalId: grafanaPrincipalId
  }
  scope: azureMonitorWorkspace
}
// 
