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

3. **Parameters**:
    - Review and update the [`parameters.json`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fparameters.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "c:\Users\jmasengesho\OneDrive - Microsoft\Documents\workspace\AKS Playground\repos\private-aks-bicep-demo\parameters.json") file with the appropriate values for your environment.
    - Key parameters include:
        - [`location`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A4%2C%22character%22%3A9%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition"): The Azure region for the deployment.
        - [`resourceGroupName`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A7%2C%22character%22%3A9%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition"): The name of the resource group.
        - [`vnetResourceGroupName`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A10%2C%22character%22%3A9%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition"): The name of the resource group containing the virtual network.
        - [`vnetName`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A13%2C%22character%22%3A9%7D%7D%2C%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fmodules%2FvnetContributorRole.bicep%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A2%2C%22character%22%3A6%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition"): The name of the virtual network.
        - [`subnetName`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A16%2C%22character%22%3A9%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition"): The name of the subnet.
        - [`networkPlugin`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A19%2C%22character%22%3A9%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition"): The network plugin to use (e.g., [`azure`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A1%2C%22character%22%3A42%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition")).
        - [`networkPluginMode`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A22%2C%22character%22%3A9%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition"): The network plugin mode (e.g., [`overlay`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A23%2C%22character%22%3A22%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition")).
        - [`networkPolicy`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A25%2C%22character%22%3A9%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition"): The network policy to use (e.g., [`calico`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A26%2C%22character%22%3A22%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition")).
        - [`outboundType`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A28%2C%22character%22%3A9%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition"): The outbound type for the AKS cluster (e.g., [`userDefinedRouting`](command:_github.copilot.openSymbolFromReferences?%5B%22%22%2C%5B%7B%22uri%22%3A%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fscenarios%2Fprivate-byodns%2Fparameters-example.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%22pos%22%3A%7B%22line%22%3A29%2C%22character%22%3A22%7D%7D%5D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "Go to definition")).

4. **Role Assignments**:
    - The deployment includes role assignments for the virtual network and DNS zones.
    - Ensure that the service principal or managed identity used for the deployment has the necessary permissions to assign roles.

## Example Parameters

Here is an example of the [`parameters.json`](command:_github.copilot.openRelativePath?%5B%7B%22scheme%22%3A%22file%22%2C%22authority%22%3A%22%22%2C%22path%22%3A%22%2Fc%3A%2FUsers%2Fjmasengesho%2FOneDrive%20-%20Microsoft%2FDocuments%2Fworkspace%2FAKS%20Playground%2Frepos%2Fprivate-aks-bicep-demo%2Fparameters.json%22%2C%22query%22%3A%22%22%2C%22fragment%22%3A%22%22%7D%2C%222fe2e38b-4a6d-4163-9446-6fda9c33b3ca%22%5D "c:\Users\jmasengesho\OneDrive - Microsoft\Documents\workspace\AKS Playground\repos\private-aks-bicep-demo\parameters.json") file:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "value": "eastus"
        },
        "resourceGroupName": {
            "value": "myResourceGroup"
        },
        "vnetResourceGroupName": {
            "value": "myVnetResourceGroup"
        },
        "vnetName": {
            "value": "myVnet"
        },
        "subnetName": {
            "value": "mySubnet"
        },
        "networkPlugin": {
            "value": "azure"
        },
        "networkPluginMode": {
            "value": "overlay"
        },
        "networkPolicy": {
            "value": "calico"
        },
        "outboundType": {
            "value": "userDefinedRouting"
        }
    }
}
```

Make sure to update the values as per your environment before deploying.