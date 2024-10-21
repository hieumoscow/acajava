az login --service-principal -u $AZ_APP_ID -p $AZ_APP_SECRET --tenant $AZ_TENANT_ID
az account set --subscription $AZ_SUB_ID
az extension add --name spring
az spring app deploy \
    --resource-group $RG_NAME_DEV \
    --service $ASA_NAME_DEV \
    --name $APP_NAME \
    --artifact-path target/$APP_NAME-$APP_VER.jar
