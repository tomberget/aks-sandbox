# Terratest Sandbox

A sandbox for testing AKS in Azure. For now, tests are limited to:

- Resource group
  - Name
- AKS
  - Cluster Name
  - Location

> This project makes use of the [EditorConfig](https://editorconfig.org/) in order to maintain consistency. For VS Code, there is an extension you need to install in order for it to work :)

## Execute

### Terraform Plan or Apply

In order to run the terraform script and create whatever resources you need, please have a look at the **Have fun and run** section at the bottom of the page, for environmental variables that need to be exported. In addition, please execute `plan` and `apply` while adding the `--var-file` addition, like so:

**PLAN**

```sh
terraform plan --var-file tfvars/$TF_ENVIRONMENT.tfvars
```

**APPLY**

```sh
terraform apply --var-file tfvars/$TF_ENVIRONMENT.tfvars
```

### Terratest

*Terratest* scripts does not need be executed from the `test/` folder. But, if you do not, you need to add `-v` to make the test verbose. Also, since spinning up and AKS cluster takes a bit longer than your average resource, you need to define a timeout that is larger than the normal 10 minutes for *Go* tests. Execute the test by:

```sh
go test -v -timeout 30m ./...
```

> This will provide a 30 minute window for the go tests to run.
> The `./...` section means, execute all tests in this folder, and all subfolders.

#### Nice to know about Terratest

In order to not destroy resources create during normal *Terraform* applies, the *Terratest* will create its own workspace in the state file, create the resources enabled in the `test/terratest.tfvars`, do the asserts, destroy the resources and finally set the original workspace active and delete the `terratest-XYZXY` workspace.

While in the middle of trial and error, the following little command might come in handy - to delete workspaces that are empty and piling up :)

```sh
terraform workspace select sandbox && terraform workspace list | grep terratest | xargs -n 1 -p terraform workspace delete
```

> NOTE that you must agree to delete each workspace, by pressing the `y` button. `n` to cancel.

## Creating a *Service Principal* using the *AZ CLI*

### Creating a *Service Principal* with certificate

First of all, define the *Service Principal* **name**, the *Resource Group* **name** and the location and *Key Vault* to use. This can be set as environmental variables, and reused later - like this:

```bash
export SP_NAME=sp-terraform \
RESOURCE_GROUP_NAME=iac \
LOCATION=westeurope \
RANDSTRING=$(echo $RANDOM | md5sum | head -c 5) # This is necessary in order to create unique names, where that is required
```

Then, create the *Resource Group* and *Key Vault* necessary for the *Service Principal*:

```bash
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION --tags created=azcli purpose=iac
az keyvault create --name iacvault"$RANDSTRING" --resource-group $RESOURCE_GROUP_NAME --location $LOCATION \
--tags created=azcli purpose=iac
```

Create the Service Principal using the following command:

> **NOTE**
> The `$ARM_SUBSCRIPTION_ID` must be exported before running the below command

```bash
az ad sp create-for-rbac --name $SP_NAME \
--role Contributor \
--scopes /subscriptions/$ARM_SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME \
--create-cert \
--cert "$SP_NAME"-cert \
--keyvault iacvault"$RANDSTRING" \
> ~/.azure_sp/sp-terraform.json
```

> **TIP**
> In case you do not want to create the output as file, remove the trailing `\` and the list line from the command above.

Export the certificate:

```bash
az keyvault secret download --file /path/to/cert.pfx --vault-name iacvault"$RANDSTRING" --name "$SP_NAME"-cert --encoding base64
```

Now, enter the Azure Portal, and add the *Service Principal* as a **Contributor** (or other proper role) to the *Subscription*.

### Create a *VNET* to use for the *Storage Account*

A VNET should not be created to support the IaC alone, and should be something that a bit more thought is put into. However, in order to create one quickly and easy, and in the `iac` resource group, you can use the command below.

> A *VNET* is necessary for the *Storage Account* to function.

```bash
az network vnet create -g $RESOURCE_GROUP_NAME -n iacvnet --address-prefix 10.255.0.0/16 \
--subnet-name iacsubnet01 --subnet-prefix 10.255.0.0/24 --location $LOCATION \
--tags created=azcli purpose=iac
```

### Create a *Storage Account*

The Storage Account is only for holding the state files, and does not require the worlds hottest disks. It is also easier to create manually, so no CLI example for this (yet).

> Remember to create the *Storage Account Container* as well, as that is necessary for the state file to be created.

## Have fun and run

An easy way to define all necessary environmental variables, is to create a `.tfconfig` file in the root folder of the *Terraform* script. The content should look a little something like this, depending on where files have been saved (or if they have been), and if they are encrypted using **GPG** or not:

```bash
# Terraform provider
export ARM_SUBSCRIPTION_ID="<guid>"
export ARM_TENANT_ID=$(gpg --decrypt $HOME/.azure_sp/sp-terraform.json.gpg | jq -r '.tenant')
export ARM_ENVIRONMENT="public"
export ARM_CLIENT_ID=$(gpg --decrypt $HOME/.azure_sp/sp-terraform.json.gpg | jq -r '.appId')
export ARM_CLIENT_CERTIFICATE_PATH="$HOME/.azure_sp/cert.pfx"

# Terraform environment
export TF_ENVIRONMENT="sandbox"

# Define workspace
terraform workspace select $TF_ENVIRONMENT
```
