count = 0
class SyncSuiteSetupTest

  @isValid:true

  suiteSetup:(test)=>
    console.log("SyncSuiteSetupTest.suiteSetup")
    test.isTrue true
    @isValid = false

  testSuiteSetup:(test)=>
    test.isFalse @isValid


try
  TestRunner.run(new SyncSuiteSetupTest())
catch err
  console.error(err.stack)

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
    console.log("AsyncSuiteSetupTest.suiteSetup")
    x = "a"
    withLatency 500, onComplete =>
      @isValid = false
      test.equal x, "b"
    x = "b"


  testAsyncSuiteSetup:(test)=>
    test.isFalse @isValid

try
  TestRunner.run(new AsyncSuiteSetupTest())
catch err
  console.error(err.stack)



class SyncSuiteTearDownTest

  isValid:true

  suiteSetup:(test)=>
    console.log("SyncSuiteTearDownTest.suiteSetup")
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
    console.log("SyncSuiteTearDownTest.suiteTearDown")
    test.isFalse @isValid
    @changeIsValidValue()


try
  TestRunner.run(new SyncSuiteTearDownTest())
catch err
  console.error(err.stack)


class AsyncSuiteTearDownTest

  isValid:true

  suiteSetup:(test,onComplete)=>
    console.log("AsyncSuiteTearDownTest.suiteSetup")
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
    console.log("AsyncSuiteTearDownTest.suiteTearDown")
    @changeIsValidValue onComplete =>
      test.isTrue @isValid


try
  TestRunner.run(new AsyncSuiteTearDownTest())
catch err
  console.error(err.stack)


class MultipleTestSyncSuiteTest

  self = @
  isValid:true

  constructor:->
    self = @

  suiteSetup:(test)->
    console.log("MultipleTestSyncSuiteTest.suiteSetup")
    test.isTrue self.isValid
    self.changeIsValidValue()

  testOne: (test)->
    console.log("MultipleTestSyncSuiteTest.testOne")
    test.isFalse self.isValid
    self.changeIsValidValue()

  testTwo: (test)->
    console.log("MultipleTestSyncSuiteTest.testTwo")
    test.isTrue self.isValid
    self.changeIsValidValue()

  changeIsValidValue:->
    if self.isValid
      self.isValid = false
    else
      self.isValid = true

  suiteTearDown:(test)->
    console.log("MultipleTestSyncSuiteTest.suiteTearDown")
    test.isFalse(self.isValid)
    self.changeIsValidValue()


try
  TestRunner.run(new MultipleTestSyncSuiteTest())
catch err
  console.error(err.stack)


class MultipleTestAsyncSuiteTest

  self = null

  isValid:true

  constructor:->
    self = @

  suiteSetup:(test,onComplete)->
    console.log("MultipleTestAsyncSuiteTest.suiteSetup")
    self.changeIsValidValue onComplete =>
      test.isFalse self.isValid


  testOne: (test,onComplete)->
    console.log("MultipleTestAsyncSuiteTest.testOne")
    self.changeIsValidValue onComplete =>
      test.isTrue self.isValid

  testTwo: (test,onComplete)->
    console.log("MultipleTestAsyncSuiteTest.testTwo")
    self.changeIsValidValue onComplete =>
      test.isFalse self.isValid

  changeIsValidValue:(cb)=>
    withLatency( 1000,->
      if self.isValid
        self.isValid = false
      else
        self.isValid = true
      cb()
    )

  suiteTearDown:(test,onComplete)->
    console.log("MultipleTestAsyncSuiteTest.suiteTearDown")
    self.changeIsValidValue onComplete =>
      test.isTrue self.isValid

try
  TestRunner.run(new MultipleTestAsyncSuiteTest())
catch err
  console.error(err.stack)



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
  TestRunner.run(new ClientServerSyncSuiteTest())
catch err
  console.error(err.stack)


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
  TestRunner.run(new ClientServerAsyncSuiteTest())
catch err
  console.error(err.stack)

class CompleteSuiteTest

  self = @
  count = 0
  @isValid: true

  constructor:->
    self = @

  suiteSetup:(test)->
    console.warn "suiteSetup: "+count++
    self.isValid = true

  suiteTearDown:(test)->
    console.warn "suiteTearDown: "+count++
    self.isValid = false

#  setup:(test)->
#  tearDown:(test)->


  tests:[
    {
      name:"tests - Sync CompleteSuiteTest"
      func:(test)->
        console.warn "tests - Sync CompleteSuiteTest: "+count++
        test.isTrue self.isValid
        self.isValid = false
    },
    {
      name:"tests - Async CompleteSuiteTestTwo"
      func:(test,onComplete)->
        withLatency 200,onComplete ->
          console.warn "tests - Async CompleteSuiteTest: "+count++
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
        console.warn "tests - Client CompleteSuiteTest: "+count++
        test.isFalse self.isValid
        self.isValid = true
    },
    {
      name:"tests - Server CompleteSuiteTest"
      type:"server"
      func:(test)->
        console.warn "tests - Server CompleteSuiteTest: "+count++
        test.isTrue self.isValid
    }

  ]

  testValidIsTrue:(test)->
    console.warn "testValidIsTrue: "+count++
    test.isTrue self.isValid
    self.isValid = false

  testValidIsFalse:(test)->
    console.warn "testValidIsFalse: "+count++
    test.isFalse self.isValid
    if Meteor.isServer
      self.isValid = false
    else
      self.isValid = true


  clientTestValidIsTrueOnlyClient:(test)->
    console.warn "clientValidIsTrueOnlyClient: "+count++
    test.isTrue self.isValid

  serverTestValidIsFalseOnlyServer:(test)->
    console.warn "clientValidIsFalseOnlyServer: "+count++
    test.isFalse self.isValid


try
  TestRunner.run(new CompleteSuiteTest())
catch err
  console.error(err.stack)


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
  TestRunner.run(new SkipSuiteTest())
catch err
  console.error(err.stack)
