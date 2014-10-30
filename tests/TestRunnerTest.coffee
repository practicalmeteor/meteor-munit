count = 0
class SyncSuiteSetupTest

  @isValid:true

  suiteSetup:(test)=>
    log.info("SyncSuiteSetupTest.suiteSetup")
    test.isTrue true
    @isValid = false

  testSuiteSetup:(test)=>
    test.isFalse @isValid


try
  Munit.run(new SyncSuiteSetupTest())
catch err
  log.error(err.stack)

withLatency = (time,cb)->
  Meteor.setTimeout(->
    cb()
  ,time)


#lvTestAsyncMulti "test",[
#  (test,exp)->
#    x = "a"
#    withLatency exp ->
#      test.equal x, "b"
#    x = "b"
#]

class AsyncSuiteSetupTest

  @isValid:true

  suiteSetup:(test,onComplete)=>
    log.info("AsyncSuiteSetupTest.suiteSetup")
    x = "a"
    withLatency 500, onComplete =>
      @isValid = false
      test.equal x, "b"
    x = "b"


  testAsyncSuiteSetup:(test)=>
    test.isFalse @isValid

try
  Munit.run(new AsyncSuiteSetupTest())
catch err
  log.error(err.stack)



class SyncSuiteTearDownTest

  isValid:true

  suiteSetup:(test)=>
    log.info("SyncSuiteTearDownTest.suiteSetup")
    test.isTrue @isValid
    @changeIsValidValue()

  testSyncSuiteTearDown:(test)=>
    test.isFalse @isValid

  changeIsValidValue:=>
    if @isValid
      @isValid = false
    else
      @isValid = true

  suiteTearDown:(test)=>
    log.info("SyncSuiteTearDownTest.suiteTearDown")
    test.isFalse @isValid
    @changeIsValidValue()


try
  Munit.run(new SyncSuiteTearDownTest())
catch err
  log.error(err.stack)


class AsyncSuiteTearDownTest

  isValid:true

  suiteSetup:(test,onComplete)=>
    log.info("AsyncSuiteTearDownTest.suiteSetup")
    @changeIsValidValue onComplete =>
      test.isFalse @isValid


  testAsyncSuiteTearDown:(test)=>
    test.isFalse @isValid

  changeIsValidValue:(cb)=>
    withLatency( 200,=>
      if @isValid
        @isValid = false
      else
        @isValid = true
      cb()
    )

  suiteTearDown:(test,onComplete)=>
    log.info("AsyncSuiteTearDownTest.suiteTearDown")
    @changeIsValidValue onComplete =>
      test.isTrue @isValid


try
  Munit.run(new AsyncSuiteTearDownTest())
catch err
  log.error(err.stack)


class MultipleTestSyncSuiteTest

  self = @
  isValid:true

  constructor:->
    self = @

  suiteSetup:(test)->
    log.info("MultipleTestSyncSuiteTest.suiteSetup")
    test.isTrue self.isValid
    self.changeIsValidValue()

  testOne: (test)->
    log.info("MultipleTestSyncSuiteTest.testOne")
    test.isFalse self.isValid
    self.changeIsValidValue()

  testTwo: (test)->
    log.info("MultipleTestSyncSuiteTest.testTwo")
    test.isTrue self.isValid
    self.changeIsValidValue()

  changeIsValidValue:->
    if self.isValid
      self.isValid = false
    else
      self.isValid = true

  suiteTearDown:(test)->
    log.info("MultipleTestSyncSuiteTest.suiteTearDown")
    test.isFalse(self.isValid)
    self.changeIsValidValue()


try
  Munit.run(new MultipleTestSyncSuiteTest())
catch err
  log.error(err.stack)






class MultipleTestAsyncSuiteTest

  self = null

  value: null

  name: "MultipleTestAsyncSuiteTest - verify multiple calls to testAsyncMulti are run serially"

  changeTestValue: (value)->
    @value = value
    log.info("value=",value)

  constructor:->
    self = @

  suiteSetup:(test)->
    log.info("MultipleTestSyncSuiteTest.suiteSetup")
    self.changeTestValue("suiteSetup")
    test.equal self.value,"suiteSetup"


  testOne: (test,onComplete)->
    log.info("MultipleTestAsyncSuiteTest.testOne")
    test.equal self.value,"suiteSetup"
    withLatency 100, onComplete ->
      test.equal self.value,"suiteSetup"
      self.changeTestValue("testOne")


  testTwo: (test,onComplete)->
    log.info("MultipleTestAsyncSuiteTest.testTwo")
    test.equal self.value,"testOne"


try
  Munit.run(new MultipleTestAsyncSuiteTest())
catch err
  log.error(err.stack)




class ClientServerSyncSuiteTest

  clientTestOne:(test)->
    test.isTrue Meteor.isClient
    test.isFalse Meteor.isServer


  clientTestTwo:(test)->
    test.isTrue Meteor.isClient
    test.isFalse Meteor.isServer


  serverTestOne:(test)->
    test.isTrue Meteor.isServer
    test.isFalse Meteor.isClient


  serverTestTwo:(test)->
    test.isTrue Meteor.isServer
    test.isFalse Meteor.isClient


try
  Munit.run(new ClientServerSyncSuiteTest())
catch err
  log.error(err.stack)


class ClientServerAsyncSuiteTest

  clientTestOne:(test,onComplete)->
    withLatency( 1000,onComplete ->
      test.isTrue Meteor.isClient
      test.isFalse Meteor.isServer
    )

  clientTestTwo:(test,onComplete)->
    withLatency( 1000,onComplete ->
      test.isTrue Meteor.isClient
      test.isFalse Meteor.isServer
    )

  serverTestOne:(test,onComplete)->
    withLatency( 1000,onComplete ->
      test.isTrue Meteor.isServer
      test.isFalse Meteor.isClient
    )


  serverTestTwo:(test,onComplete)->
    withLatency( 1000,onComplete ->
      test.isTrue Meteor.isServer
      test.isFalse Meteor.isClient
    )


try
  Munit.run(new ClientServerAsyncSuiteTest())
catch err
  log.error(err.stack)

class CompleteSuiteTest

  self = @
  count = 0
  @isValid: true

  constructor:->
    self = @

  suiteSetup:(test)->
    log.info "suiteSetup: "+count++
    self.isValid = true

  suiteTearDown:(test)->
    log.info "suiteTearDown: "+count++
    self.isValid = false

#  setup:(test)->
#  tearDown:(test)->


  tests:[
    {
      name:"tests - Sync CompleteSuiteTest"
      func:(test)->
        log.info "tests - Sync CompleteSuiteTest: "+count++
        test.isTrue self.isValid
        self.isValid = false
    },
    {
      name:"tests - Async CompleteSuiteTestTwo"
      func:(test,onComplete)->
        withLatency 200,onComplete ->
          log.info "tests - Async CompleteSuiteTest: "+count++
          test.isFalse self.isValid
          if Meteor.isServer
            self.isValid = true
          else
            self.isValid = false

    },
    {
      name:"tests - Client CompleteSuiteTest"
      type:"client"
      func:(test)->
        log.info "tests - Client CompleteSuiteTest: "+count++
        test.isFalse self.isValid
        self.isValid = true
    },
    {
      name:"tests - Server CompleteSuiteTest"
      type:"server"
      func:(test)->
        log.info "tests - Server CompleteSuiteTest: "+count++
        test.isTrue self.isValid
    }

  ]

  testValidIsTrue:(test)->
    log.info "testValidIsTrue: "+count++
    test.isTrue self.isValid
    self.isValid = false

  testValidIsFalse:(test)->
    log.info "testValidIsFalse: "+count++
    test.isFalse self.isValid
    if Meteor.isServer
      self.isValid = false
    else
      self.isValid = true


  clientTestValidIsTrueOnlyClient:(test)->
    log.info "clientValidIsTrueOnlyClient: "+count++
    test.isTrue self.isValid

  serverTestValidIsFalseOnlyServer:(test)->
    log.info "clientValidIsFalseOnlyServer: "+count++
    test.isFalse self.isValid


try
  Munit.run(new CompleteSuiteTest())
catch err
  log.error(err.stack)


class SkipSuiteTest

  tests:[
    {
      name:"Skip tests one"
      skip: true
      func:(test)->
        test.fail("This should pass")

    }
    {
      name:"Skip tests two"
      skip: true
      func:(test)->
        test.fail("This should pass")

    }
    {
      name:"Skip tests three"
      skip: true
      func:(test)->
        test.fail("This should pass")
    }
  ]


try
  Munit.run(new SkipSuiteTest())
catch err
  log.error(err.stack)





class TestsAsObjectSuiteTest
  tests:
    simpleTest: (test) -> test.equal(test.test_case.shortName, 'simpleTest')
    'My Test': (test) -> test.equal(test.test_case.shortName, 'My Test')

    foo:
      name: 'My explicit name'
      func: (test) -> test.equal(test.test_case.shortName, 'My explicit name')

    skipTest:
      skip: true
      func:(test)->
        test.fail("This should pass")

try
  Munit.run(new TestsAsObjectSuiteTest())
catch err
  log.error(err.stack)


