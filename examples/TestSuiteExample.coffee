class TestSuiteExample
	
  name: "TestSuiteExample"

  suiteSetup: ()->

  setup: ->

  testAsync: (test, done) ->
    myAsyncFunction done((value) ->
      test.isNotNull value
    )

  testIsValid: (test) ->
    test.isTrue true

  clientTestIsClient: (test) ->
    test.isTrue Meteor.isClient
    test.isFalse Meteor.isServer

  serverTestIsServer: (test) ->
    test.isTrue Meteor.isServer
    test.isFalse Meteor.isClient

  tests: [
    {
      name: "sync test"
      func: (test)->

    },
    {
      name: "async test"
      skip: true
      func: (test, done)->
        myAsyncFunction done((value)->
          test.isNotNull(value)
        )

    },
    {
      name: "three"
      type: "client"
      timeout: 5000
      func: (test)->
        test.isTrue Meteor.isClient
    }
  ]

  tearDown: ->

  suiteTearDown: ->

spacejam.munit.run(new TestSuiteExample())
