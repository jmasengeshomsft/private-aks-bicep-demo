# AKS Playground

This repository contains Bicep templates for deploying an Azure Kubernetes Service (AKS) cluster.

## Structure

The repository has the following structure:

- `main.bicep`: The main Bicep file that orchestrates the deployment of the AKS cluster.
- `modules/aks/aks.bicep`: The Bicep file that defines the AKS cluster.
- `modules/aks/aksNodePool.bicep`: The Bicep file that defines the node pool for the AKS cluster.
- `parameters.json`: The JSON file that contains the parameters for the Bicep files.
- `scenarios/`: Directory containing different deployment scenarios.

## Scenarios

### Stable Private Cluster

- **Folder**: `scenarios/stable-private-cluster`
- **Description**: This scenario deploys a stable AKS cluster with a private API server access profile, no preview features, and no BYO DNS zone.
- **Deployment**: To deploy this scenario, navigate to the `scenarios/stable-private-cluster` folder and use the following Azure CLI command:
  ```sh
  az deployment group create --resource-group 'aks-rg' --template-file main.bicep --parameters parameters.json
  ```
- **Notes**: Ensure that the virtual network and subnet specified in the parameters file are correctly configured to allow access to the API server.

### Private Cluster with BYO DNS

- **Folder**: `scenarios/private-byodns`
- **Description**: This scenario deploys an AKS cluster with a private API server access profile and Bring Your Own DNS (BYO DNS) configuration.
- **Deployment**: To deploy this scenario, navigate to the `scenarios/private-byodns` folder and use the following Azure CLI command:
  ```sh
  az deployment group create --resource-group 'aks-rg' --template-file main.bicep --parameters parameters.json
  ```
- **Notes**: Ensure that the DNS zone and records are correctly set up to resolve the private API server endpoint. For more information, refer to the [Azure documentation](https://learn.microsoft.com/en-us/azure/aks/private-clusters?tabs=default-basic-networking%2Cazure-portal#configure-a-private-dns-zone).

### Experimental Private Cluster

- **Folder**: `scenarios/experimental-private-cluster`
- **Description**: This scenario deploys an experimental AKS cluster with a private API server access profile and multiple preview features enabled.
- **Deployment**: To deploy this scenario, navigate to the `scenarios/experimental-private-cluster` folder and use the following Azure CLI command:
  ```sh
  az deployment group create --resource-group 'aks-rg' --template-file main.bicep --parameters parameters.json
  ```
- **Notes**: This scenario includes several preview features. Ensure that you are aware of the implications of using these features in a production environment.

## VNet Integration for AKS

Virtual Network (VNet) integration allows your AKS cluster to communicate securely with other resources in your virtual network. This integration provides the following benefits:

- **Enhanced Security**: By isolating your AKS cluster within a VNet, you can control inbound and outbound traffic using network security groups (NSGs).
- **Private Access**: With VNet integration, you can configure private access to the AKS API server, ensuring that it is only accessible within the VNet.
- **Service Endpoints**: You can use VNet service endpoints to connect to Azure services securely.

For more information on VNet integration for AKS, refer to the [Azure documentation](https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni).

## Bring Your Own DNS (BYO DNS)

This deployment uses a Bring Your Own DNS (BYO DNS) configuration. BYO DNS allows you to use your own DNS servers and zones to resolve the private API server endpoint. This is useful for scenarios where you need to integrate with existing DNS infrastructure.

For more information on configuring a private DNS zone, refer to the [Azure documentation](https://learn.microsoft.com/en-us/azure/aks/private-clusters?tabs=default-basic-networking%2Cazure-portal#configure-a-private-dns-zone).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.