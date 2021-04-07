param AppPlanServiceName string = 'AppPlanService_Bicep'
param kind string = 'linux'
param sku string = 'B1'
param WebSiteName string = 'site-bicep-007'
param dockerImage string = 'nginxdemos/hello'
param dockerImageTag string = 'latest'

resource AppPlanService 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: AppPlanServiceName
  location: resourceGroup().location
  kind: kind
  sku: {
    name: sku
    }
  properties:{
    reserved: true
  }
        
}
output AppPlanService string = AppPlanService.id

resource WebSite 'Microsoft.Web/sites@2020-06-01' = {
  name: WebSiteName
  location: resourceGroup().location
  properties:{
    siteConfig:{
      appSettings:[
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://index.docker.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: ''
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: ''
        }
        {
          name: 'WEBSITE_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      linuxFxVersion: 'DOCKER|${dockerImage}:${dockerImageTag}'
    }
    serverFarmId: AppPlanService.id
  }
}
