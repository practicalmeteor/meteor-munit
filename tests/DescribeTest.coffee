@expect = chai.expect


describeSuiteTest =
  name: 'Declaring "describe" semantics'
  suiteSetup: -> describe.autoRun = false
  suiteTearDown: -> describe.autoRun = true
  tests:
    'defines a test suite name': (test) ->
      suite = describe 'my name', ->
      test.equal(suite.name, 'my name')

    'defines a test suite "suiteSetup" function': (test) ->
      func = ->
      suite = describe 'my name', ->
                beforeAll(func)
      test.instanceOf(suite.suiteSetup, Function)

    'defines a test suite "setup" function': (test) ->
      func = ->
      suite = describe 'my name', ->
                beforeEach (func)
      test.instanceOf(suite.setup, Function)

    'defines a test suite "tearDown" function': (test) ->
      func = ->
      suite = describe 'my name', ->
                afterEach(func)
      test.instanceOf(suite.tearDown, Function)

    'defines a test suite "suiteTearDown" function': (test) ->
      func = ->
      suite = describe 'my name', ->
                afterAll(func)
      test.instanceOf(suite.suiteTearDown, Function)

    'allows nesting of describe blocks': (test) ->
      
      suite = describe 'parent', -> describe 'child', -> describe 'grand child', ->

      test.equal(suite.nestedPrefix, 'child - grand child - ')



try
  Munit.run(describeSuiteTest)
catch err
  console.error(err.stack)



# --------------------------------------------------------------------------


describe 'Running tests from within a "describe" block', ->
  wasBeforeAllRun = null
  beforeEachContext = null

  beforeAll -> wasBeforeAllRun = true
  beforeEach -> beforeEachContext = @

  it 'passes the [TestCaseResults] as [this]', ->
    expect(@test.test_case.shortName).to.equal 'passes the [TestCaseResults] as [this]'
    expect(@func).to.be.an.instanceOf Function
    expect(@waitFor).to.be.an.instanceOf Function
    expect(@suite.name).to.equal 'Running tests from within a "describe" block'

  it 'runs [beforeAll]', ->
    expect(wasBeforeAllRun).to.be.true

  it 'runs [beforeEach]', ->
    expect(beforeEachContext.test.test_case.shortName).to.equal 'runs [beforeEach]'


describe 'Running tests from within nested describe blocks', ->

  sharedData = {}

  beforeEach -> @suite.shared = sharedData

  it 'runs the first-level tests correctly', ->

    expect(@suite.name).to.equal 'Running tests from within nested describe blocks'
    expect(@test.test_case.shortName).to.equal "runs the first-level tests correctly"
    expect(@test.test_case.name).to.equal "#{@suite.name} - runs the first-level tests correctly"
    expect(@suite.shared).to.equal sharedData

  describe 'when nesting', ->

    it 'adds dashes to generate tinytest group paths', ->

      expect(@suite.name).to.equal 'Running tests from within nested describe blocks'
      expect(@test.test_case.shortName).to.equal "adds dashes to generate tinytest group paths"
      expect(@test.test_case.name).to.equal "#{@suite.name} - when nesting - #{@test.test_case.shortName}"
      expect(@suite.shared).to.equal sharedData

    describe 'multi nesting', ->

      it 'can handle any depth of nesting', ->

        expect(@suite.name).to.equal 'Running tests from within nested describe blocks'
        expect(@test.test_case.shortName).to.equal "can handle any depth of nesting"
        expect(@test.test_case.name).to.equal "#{@suite.name} - when nesting - multi nesting - #{@test.test_case.shortName}"
        expect(@suite.shared).to.equal sharedData

# --------------------------------------------------------------------------


describe 'Asynchronous tests within an "it" block', ->
  it 'is not asynchronous', ->
    expect(@isAsync).to.equal false

  it 'is asynchronous', (waitFor) ->
    onTimeout = ->
      expect(true).to.be.true
    Meteor.setTimeout waitFor(onTimeout), 50



# --------------------------------------------------------------------------


describe.skip 'Skip suite (describe.skip)', ->
  it 'should fail', ->
    expect(true).to.equal false


describe 'Skip a test (it.skip)', ->
  it.skip 'should fail', ->
    throw new Error('This should not run')

  it.skip 'should fail',
    func: ->
      throw new Error('This should not run')



# --------------------------------------------------------------------------


describe 'Specifying execution domain for "it" (client / server)', ->
  it.client 'runs on the client only', ->
    if Meteor.isServer
      throw new Error('This should not run on server')

  it.server 'runs on the server only', ->
    if Meteor.isClient
      throw new Error('This should not run on client')

  it.client.skip 'skips a client-only test', ->
    throw new Error('This should not run')

  it.server.skip 'skips a server-only test', ->
    throw new Error('This should not run')



describe.client 'Specifying execution domain for "describe" (client)', ->
  it 'runs on the client only', ->
    if Meteor.isServer
      throw new Error('This should not run on server')

  it.server 'overrides parent "describe.client" and runs on the server', ->
    if Meteor.isClient
      throw new Error('This should not run on client')



describe.server 'Specifying execution domain for "describe" (server)', ->
  it 'runs on the server only', ->
    if Meteor.isClient
      throw new Error('This should not run on client')


  it.client 'overrides parent "describe.server" and runs on the client', ->
    if Meteor.isServer
      throw new Error('This should not run on server')



describe.client.skip 'Skipping "describe.client"', ->
  it 'should fail', ->
    throw new Error('This should not run')


describe.server.skip 'Skipping "describe.server"', ->
  it 'should fail', ->
    throw new Error('This should not run')


