HistoryExporterService = require('./HistoryExporterService')

module.exports = (bus) ->

  bus.private('reportExcelDumpAll').require('fileName','projectId').on((req, fileName, projectId) ->
    historyExporterService = new HistoryExporterService(fileName, projectId)
    historyExporterService.excelDumpAll()
  )
