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



try
  Munit.run(describeSuiteTest)
catch err
  console.error(err.stack)



# --------------------------------------------------------------------------


describe 'Running tests from within a "describe" block', ->

  beforeEachContext = null
  beforeAllContext = null

  beforeAll ->
    beforeAllContext = this
    @wasBeforeAllRun = true

  beforeEach ->
    beforeEachContext = this
    @wasBeforeEachRun = true

  it 'passes the [TestCaseResults] as [this]', ->
    expect(@test.test_case.shortName).to.equal 'passes the [TestCaseResults] as [this]'
    expect(@func).to.be.an.instanceOf Function
    expect(@waitFor).to.be.an.instanceOf Function
    expect(@suite.name).to.equal 'Running tests from within a "describe" block'

  it 'runs [beforeAll]', ->
    expect(beforeAllContext).to.equal this
    expect(@wasBeforeAllRun).to.be.true

  it 'runs [beforeEach]', ->
    expect(beforeEachContext.test.test_case.shortName).to.equal 'runs [beforeEach]'

  it 'shares the test context with before hooks', ->
    expect(beforeEachContext).to.equal this
    expect(@wasBeforeEachRun).to.be.true


describe 'Running tests from within nested describe blocks', ->

  ranBefore = false

  beforeEach ->
    ranBefore = true
    console.log "[BEFORE EACH] #{@test.test_case.name}"

  afterEach ->
    console.log "[AFTER EACH] #{@test.test_case.name}"

  it 'runs the first-level tests correctly', ->

    expect(@suite.name).to.equal 'Running tests from within nested describe blocks'
    expect(@test.test_case.shortName).to.equal "runs the first-level tests correctly"
    expect(@test.test_case.name).to.equal "#{@suite.name} - #{@test.test_case.shortName}"
    expect(ranBefore).to.be.true

  describe 'when nesting', ->

    it.client 'adds dashes to generate tinytest group paths', ->

      expect(@suite.name).to.equal 'Running tests from within nested describe blocks'
      expect(@test.test_case.shortName).to.equal "adds dashes to generate tinytest group paths"
      expect(@test.test_case.name).to.equal "#{@suite.name} - when nesting - #{@test.test_case.shortName}"
      expect(ranBefore).to.be.true

    it 'runs nested in both environments', ->

    describe.server 'server only', ->

      it 'can handle any depth of nesting', ->

        expect(@suite.name).to.equal 'Running tests from within nested describe blocks'
        expect(@test.test_case.shortName).to.equal "can handle any depth of nesting"
        expect(@test.test_case.name).to.equal "#{@suite.name} - when nesting - server only - #{@test.test_case.shortName}"
        expect(ranBefore).to.be.true

  describe.client 'multiple nested on same level', ->

    it 'it shows up in the right order', ->

      expect(@suite.name).to.equal 'Running tests from within nested describe blocks'
      expect(@test.test_case.shortName).to.equal "it shows up in the right order"
      expect(@test.test_case.name).to.equal "#{@suite.name} - multiple nested on same level - #{@test.test_case.shortName}"
      expect(ranBefore).to.be.true

  it.server 'also works after describe blocks', ->

    expect(@suite.name).to.equal 'Running tests from within nested describe blocks'
    expect(@test.test_case.shortName).to.equal "also works after describe blocks"
    expect(@test.test_case.name).to.equal "#{@suite.name} - #{@test.test_case.shortName}"
    expect(ranBefore).to.be.true

# --------------------------------------------------------------------------


describe 'Asynchronous tests within an "it" block', ->
  it 'is not asynchronous', ->
    expect(@isAsync).to.equal false

  it 'is asynchronous', (test, waitFor) ->
    expect(@isAsync).to.equal true
    onTimeout = ->
      try
        expect(true).to.be.true
      catch err
        test.exception(err)
    Meteor.setTimeout waitFor(onTimeout), 50


describe 'Asynchronous beforeAll, beforeEach, afterEach and afterAll', ->

  beforeAll (test, waitFor) ->
    expect(@isAsync).to.equal true
    onTimeout = ->
      try
        expect(true).to.be.true
      catch err
        test.exception(err)
    Meteor.setTimeout waitFor(onTimeout), 50

  beforeEach (test, waitFor) ->
    expect(@isAsync).to.equal true
    onTimeout = ->
      try
        expect(true).to.be.true
      catch err
        test.exception(err)
    Meteor.setTimeout waitFor(onTimeout), 50

  it 'is asynchronous too', (test, waitFor) ->
    expect(@isAsync).to.equal true
    onTimeout = ->
      try
        expect(true).to.be.true
      catch err
        test.exception(err)
    Meteor.setTimeout waitFor(onTimeout), 50

  afterEach (test, waitFor) ->
    expect(@isAsync).to.equal true
    onTimeout = ->
      try
        expect(true).to.be.true
      catch err
        test.exception(err)
    Meteor.setTimeout waitFor(onTimeout), 50

  afterAll (test, waitFor) ->
    expect(@isAsync).to.equal true
    onTimeout = ->
      try
        expect(true).to.be.true
      catch err
        test.exception(err)
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


