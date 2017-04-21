request     = require('request')
fs          = require('fs')
logger      = require('logger')
config      = require('config')
fileService = require('FileService')
Promise     = require('bluebird')


class HistoryExporterService

  constructor: (@fileName, @projectId, @tracker) ->
    @excelMicroserviceEndpoint = config.get('weaver-plugin-history-exporter.services.excelMicroservice')
    @sheet = {0:{0:{}}}
    @dir = 'uploads'
    logger.code.debug("#{config.get('weaver-plugin-history-exporter.services.excelMicroservice')}")
    logger.code.debug(@fileName)
    logger.code.debug(@projectId)

  excelDumpAll: ->
    try
      promises = []
      request.payload = {}
      # request.payload.limit = 100 # just to not break everithing
      @tracker.getHistoryFor(request)
      .then((rows) =>
        promises.push(@extractHeaders(rows[0]))
        promises.push(@extractData(rows))
        Promise.all(promises)
        .then(=>
          @createExcelReport()
          .then((path) =>
            fileService.uploadFileStream(path,@fileName,@projectId)
            .then((res) ->
              logger.code.debug("The answer of Minio: #{res}")
              res
            )
          )
        ).catch((err)->
          logger.code.error(err)
        )
      )
    catch error
      logger.code.error(error)

  extractData: (rows) ->
    for row, index in rows
      @sheet[0][index+1] = {}
      i = 0
      for key, value of row
        @sheet[0][index+1]["#{i}"] = {value:value,type:'String'}
        i++
      Promise.resolve()


  extractHeaders: (row) ->
    i = 0
    for key, value of row
      @sheet[0][0]["#{i}"] = {value:key,type:'String'}
      i++
    Promise.resolve()

  createExcelReport: ->
    new Promise((resolve, reject) =>
      try
        fileStream = fs.createWriteStream("#{@dir}/#{@fileName}")
        request.post({url:"#{@excelMicroserviceEndpoint}/excel/create?fileName=#{@fileName}",headers:{"content-type": "application/json"}, json: @sheet}, (err, httpResponse, body) ->
          if err
            logger.code.error(err)
        ).pipe(fileStream)
        fileStream.on('close', =>
          resolve("#{@dir}/#{@fileName}")
        )
        fileStream.on('error', =>
          reject()
        )
      catch error
        reject()
    )

module.exports = HistoryExporterService
