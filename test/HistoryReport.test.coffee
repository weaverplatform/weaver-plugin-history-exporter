###
 To run this test copy it to the test folder in the weaver-sdk
###

Weaver = require("./test-suite")
WeaverClass = Weaver.getClass()

describe 'BB reporting pluging testing', ->

  it 'should list available plugins', ->
    WeaverClass.Plugin.list().then((plugins) ->
      plugin = i for i in plugins when i._name is 'weaver-plugin-history-exporter'
      expect(plugin).to.not.be.undefined
    )

  it 'should get a weaver-plugin-history-exporter plugin', ->
    WeaverClass.Plugin.load('weaver-plugin-history-exporter').then((plugin) ->
      assert.equal(plugin.getPluginName(), 'weaver-plugin-history-exporter')
    )

  it 'should do something for the history reporting generator', ->
    this.timeout(600000)
    WeaverClass.Plugin.load('weaver-plugin-history-exporter').then((historyReport) ->

      projectId = Weaver.currentProject().projectId

      historyReport.reportExcelDumpAll('history.xlsx', projectId)
    ).then((res) ->
      console.log "http://localhost:9487/file/downloadByID?payload=%7B%22id%22%3A%22#{res.split('-')[0]}%22%2C%22target%22%3A%22#{Weaver.currentProject().projectId}%22%2C%22authToken%22%3A%22#{Weaver.currentUser().authToken}%22%7D"
    )
