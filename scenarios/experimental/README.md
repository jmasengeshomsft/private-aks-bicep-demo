```markdown
# Experimental AKS Deployment Scenario

This folder contains Bicep templates and parameter files for deploying an experimental Azure Kubernetes Service (AKS) cluster. This deployment includes advanced configurations such as private API server access, Bring Your Own DNS (BYO DNS), auto-scaling, and several preview features.

## Structure

- [`main.bicep`](main.bicep): The main Bicep file that orchestrates the deployment of the AKS cluster.
- [`aks-experimental.bicep`](../../modules/aks/aks-experimental.bicep): The Bicep module that defines the experimental AKS cluster.
- [`parameters-example.json`](parameters-example.json): An example parameters file that provides the necessary parameters for the deployment.
- [`parameters.json`](parameters.json): The actual parameters file used for deployment. You can copy `parameters-example.json` to `parameters.json` and modify it as needed.

## Deployment

To deploy the experimental AKS cluster, use the following Azure CLI command:

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

3. **Auto-Scaling**:
    - The AKS cluster is configured with auto-scaling enabled for both the system and user node pools.
    - Review and adjust the `minNodeCount`, `maxNodeCount`, and `nodeCount` parameters in the `parameters.json` file to suit your workload requirements.

4. **Parameters**:
    - Review and update the `parameters.json` file with the appropriate values for your environment.
    - Key parameters include:
        - `location`: The Azure region for the deployment.
        - `resourceGroupName`: The name of the resource group.
        - `vnetResourceGroupName`: The name of the resource group containing the virtual network.
        - `vnetName`: The name of the virtual network.
        - `subnetName`: The name of the subnet.
        - `networkPlugin`: The network plugin to use (e.g., `azure`).
        - `networkPluginMode`: The network plugin mode (e.g., `overlay`).
        - `networkPolicy`: The network policy to use (e.g., `calico`).
        - `outboundType`: The outbound type for the AKS cluster (e.g., `loadBalancer`).

5. **Role Assignments**:
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

## Preview Features Included

1. **Azure CNI Overlay**
   - **Description**: Azure CNI Overlay is a networking mode that allows for more efficient IP address utilization in large-scale clusters.
   - **Documentation**: [Azure CNI Overlay](https://learn.microsoft.com/en-us/azure/aks/azure-cni-overlay)

2. **Web Application Routing**
   - **Description**: Web Application Routing simplifies the process of exposing applications running on AKS to the internet.
   - **Documentation**: [Web Application Routing](https://learn.microsoft.com/en-us/azure/aks/web-app-routing)

3. **User-Assigned Managed Identity**
   - **Description**: User-assigned managed identities provide a way to manage the identity lifecycle independently of the AKS cluster.
   - **Documentation**: [User-Assigned Managed Identity](https://learn.microsoft.com/en-us/azure/aks/use-managed-identity)

4. **Private DNS Zone Integration**
   - **Description**: Integrating AKS with a private DNS zone allows for private access to the API server and other cluster resources.
   - **Documentation**: [Private DNS Zone Integration](https://learn.microsoft.com/en-us/azure/aks/private-clusters#configure-a-private-dns-zone)

## Example Parameters

Here is an example of the `parameters.json` file:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "value": "centralus"
        },
        "resourceGroupName": {
            "value": "aks-playground-centralus-eshop-dev-rg"
        },
        "vnetResourceGroupName": {
            "value": "aks-playground-centralus-eshop-dev-rg"
        },
        "vnetName": {
            "value": "aks-playground-centralus-eshop-dev-vnet"
        },
        "subnetName": {
            "value": "sn-aks"
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
            "value": "loadBalancer"
        },
        "serviceCidr": {
            "value": "10.240.0.0/16"
        },
        "dnsServiceIP": {
            "value": "10.240.0.10"
        },
        "skuTier": {
            "value": "Standard"
        },
        "podCidr": {
            "value": "10.248.0.0/16"
        },
        "apiServerSubnetName": {
            "value": "sn-apim"
        },
        "kubernetesVersion": {
            "value": "1.30.0"
        },
        "availabilityZones": {
            "value": [
                "1",
                "2",
                "3"
            ]
        },
        "lawResourceGroupName": {
            "value": "aks-playground-centralus-hub-rg"
        },
        "lawName": {
            "value": "aks-playground-centralus-hub-law"
        },
        "userNodePoolSettings": {
            "value": {
                "minCount": 2,
                "maxCount": 10,
                "nodeCount": 3,
                "poolVMSize": "Standard_D2s_v3"
            }
        },
        "systemNodePoolSettings": {
            "value": {
                "minCount": 2,
                "maxCount": 5,
                "nodeCount": 2,
                "poolVMSize": "Standard_D2s_v3"
            }
        },
        "tags": {
            "value": {
                "Environment": "Development"
            }
        },
        "aksadminaccessprincipalId": {
            "value": "00000000-0000-0000-0000-000000000000"
        },
        "byoDns": {
            "value": true
        },
        "enableVnetIntegration": {
            "value": true
        },
        "dnsResourceGroupName": {
            "value": "aks-playground-centralus-hub-rg"
        },
        "privateDNSZoneAKSName": {
            "value": "privatelink.centralus.azmk8s.io"
        },
        "existingIdentityName": {
            "value": "aks-clusters-identity"
        },
        "identityResourceGroupName": {
            "value": "aks-demos"
        },
        "identitySubscriptionId": {
            "value": "00000000-0000-0000-0000-000000000000"
        },
        "advancedNetworkingEnabled": {
            "value": true
        },
        "webAppRoutingEnabled": {
            "value": true
        },
        "webAppRoutingIngressType": {
            "value": "Internal"
        }
    }
}
```

Make sure to update the values as per your environment before deploying.
```

This README provides a comprehensive overview of the deployment process, focusing on the key configurations and parameters required for the experimental AKS cluster, along with the included preview features and their documentation links.