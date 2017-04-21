HistoryExporterService = require('./HistoryExporterService')

module.exports = (bus) ->

  bus.private('reportExcelDumpAll').retrieve('tracker').require('fileName','projectId').on((req, tracker, fileName, projectId) ->
    historyExporterService = new HistoryExporterService(fileName, projectId, tracker)
    historyExporterService.excelDumpAll()
  )
