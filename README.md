# AKS with Calico and CNI Overlay via Bicep

This repository contains Bicep templates for deploying an Azure Kubernetes Service (AKS) cluster.

## Structure

The repository has the following structure:

- `main.bicep`: The main Bicep file that orchestrates the deployment of the AKS cluster.
- `modules/aks/aks.bicep`: The Bicep file that defines the AKS cluster.
- `modules/aks/aksNodePool.bicep`: The Bicep file that defines the node pool for the AKS cluster.
- `parameters.json`: The JSON file that contains the parameters for the Bicep files.

## Deployment

To deploy the AKS cluster, use the following Azure CLI command:

```sh
az deployment group create --resource-group 'aks-rg' --template-file main.bicep --parameters parameters.json
