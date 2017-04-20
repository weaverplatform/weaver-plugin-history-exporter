# Weaver plugin history exporter
Plugin to export history changes of  [weaver-sdk](https://github.com/weaverplatform/weaver-server)

## Dependencies
This plugin needs the [excel-microservice](https://github.com/sysunite/excel-microservice)
You can run it with docker:
`$ docker pull sysunite/excel-microservice`

## Install
Clone this repository on the root plugins folder in weaver-server.
`$ npm install`
`$ npm run prepublish`
To copy the config settings to weaver-server, run on weaver main folder:
`$ npm run copyPluginsConfig`

## Use
With the [weaver-sdk](https://github.com/weaverplatform/weaver-sdk-js)

Load the plugin and execute the main endpoint by:

```
Weaver.Plugin.load('weaver-plugin-history-exporter').then((historyReport) ->
	projectId = Weaver.currentProject().projectId
	historyReport.reportExcelDumpAll('dumpHistory.xlsx', projectId)
```

The plugin will answer with the name of the generated xlsx

## Test

Copy the tests under test folder to the test folder in weaver-sdk and run it.
