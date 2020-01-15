az ad sp create-for-rbac --name k8sEPSvcP --role contributor
export TF_VAR_kubernetes_client_id=*****
export TF_VAR_kubernetes_client_secret=*****

az group create -l northeurope -n MyResourceGroup
az storage account create -n mystorageaccount07012020 -g MyResourceGroup -l northeurope --sku Standard_LRS
key=$(az storage account keys list -g MyResourceGroup -n mystorageaccount07012020 --query [0].value)
az storage container create -n mystoragecontainer --account-name mystorageaccount07012020 --account-key $key


echo "$(terraform output kube_config)" > ./azurek8s
export KUBECONFIG=./azurek8s