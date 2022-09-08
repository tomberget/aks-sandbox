# AKS Sandbox

A sandbox for everything AKS in Azure.

## Creating a Managed Identity

First of all, define the name and the Resource Group of the managed identity. This can be set as environmental variables, and reused later - like this:

```bash
export MI_NAME=terraform MI_RESOURCE_GROUP=default
```

> TOP TIP
> Pipe the output of the command below to a `.json` file, in order to preserve `clientId` and `principalId` for later.

```bash
az identity create --name $MI_NAME --resource-group $MI_RESOURCE_GROUP > mi_terraform.json
```

Once the identity is created, you can use the following command to export `clientId` and `principalId` as environmental variables.

```bash
export MI_CLIENTID=$(cat mi_terraform.json | jq -r '.clientId')
export MI_PRINCIPALID=$(cat mi_terraform.json | jq -r '.principalId')
```

