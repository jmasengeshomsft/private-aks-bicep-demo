# Private BYO DNS Scenario

This folder contains Bicep templates and parameter files for deploying an Azure Kubernetes Service (AKS) cluster with a private API server access profile and Bring Your Own DNS (BYO DNS) configuration.

## Structure

- [`main.bicep`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fmain.bicep%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "c:\Users\jmasengesho\OneDrive - Microsoft\Documents\workspace\AKS Playground\repos\private-aks-bicep-demo\main.bicep"): The main Bicep file that orchestrates the deployment of the AKS cluster with private API server access.
- [`parameters-example.json`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "c:\Users\jmasengesho\OneDrive - Microsoft\Documents\workspace\AKS Playground\repos\private-aks-bicep-demo\scenarios\private-byodns\parameters-example.json"): An example parameters file that provides the necessary parameters for the deployment.
- [`parameters.json`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fparameters.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "c:\Users\jmasengesho\OneDrive - Microsoft\Documents\workspace\AKS Playground\repos\private-aks-bicep-demo\parameters.json"): The actual parameters file used for deployment. You can copy [`parameters-example.json`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "c:\Users\jmasengesho\OneDrive - Microsoft\Documents\workspace\AKS Playground\repos\private-aks-bicep-demo\scenarios\private-byodns\parameters-example.json") to [`parameters.json`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fparameters.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "c:\Users\jmasengesho\OneDrive - Microsoft\Documents\workspace\AKS Playground\repos\private-aks-bicep-demo\parameters.json") and modify it as needed.

## Deployment

To deploy the AKS cluster with the private API server access profile, use the following Azure CLI command:

```sh
az deployment group create --resource-group 'aks-rg' --template-file main.bicep --parameters parameters.json
```

## Important Notes

1. **API Server Access Profile**:
    - The AKS cluster is configured with a private API server access profile, ensuring that the API server is accessible only within the virtual network.
    - Ensure that the virtual network and subnet specified in the parameters file are correctly configured to allow access to the API server.

2. **DNS Configuration**:
    - This deployment uses a Bring Your Own DNS (BYO DNS) configuration.
    - Ensure that the DNS zone and records are correctly set up to resolve the private API server endpoint.
    - For more information on configuring a private DNS zone, refer to the [Azure documentation](https://learn.microsoft.com/en-us/azure/aks/private-clusters?tabs=default-basic-networking%2Cazure-portal#configure-a-private-dns-zone).

3. **Parameters**:
    - Review and update the [`parameters.json`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fparameters.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "c:\Users\jmasengesho\OneDrive - Microsoft\Documents\workspace\AKS Playground\repos\private-aks-bicep-demo\parameters.json") file with the appropriate values for your environment.
    - Key parameters include:
        - `location`: The Azure region for the deployment.
        - `resourceGroupName`: The name of the resource group.
        - `vnetResourceGroupName`: The name of the resource group containing the virtual network.
        - `vnetName`: The name of the virtual network.
        - `subnetName`: The name of the subnet.
        - `networkPlugin`: The network plugin to use (e.g., `azure`).
        - `networkPluginMode`: The network plugin mode (e.g., `overlay`).
        - `networkPolicy`: The network policy to use (e.g., `calico`).
        - `outboundType`: The outbound type for the AKS cluster (e.g., `userDefinedRouting`).

4. **Role Assignments**:
    - The deployment includes role assignments for the virtual network and DNS zones.
    - Ensure that the service principal or managed identity used for the deployment has the necessary permissions to assign roles.

## VNet Integration for AKS

Virtual Network (VNet) integration allows your AKS cluster to communicate securely with other resources in your virtual network. This integration provides the following benefits:

- **Enhanced Security**: By isolating your AKS cluster within a VNet, you can control inbound and outbound traffic using network security groups (NSGs).
- **Private Access**: With VNet integration, you can configure private access to the AKS API server, ensuring that it is only accessible within the VNet.
- **Service Endpoints**: You can use VNet service endpoints to connect to Azure services securely.

For more information on VNet integration for AKS, refer to the [Azure documentation](https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni).

## Bring Your Own DNS (BYO DNS)

This deployment uses a Bring Your Own DNS (BYO DNS) configuration. BYO DNS allows you to use your own DNS servers and zones to resolve the private API server endpoint. This is useful for scenarios where you need to integrate with existing DNS infrastructure.

For more information on configuring a private DNS zone, refer to the [Azure documentation](https://learn.microsoft.com/en-us/azure/aks/private-clusters?tabs=default-basic-networking%2Cazure-portal#configure-a-private-dns-zone).