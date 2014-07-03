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

    'throws if nesting describes': (test) ->
      func = ->
        describe 'parent', ->
          describe 'child', ->
      test.throws func, 'Cannot nest "describe" statements'



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
    expect(@callback).to.be.an.instanceOf Function
    expect(@suite.name).to.equal 'Running tests from within a "describe" block'

  it 'runs [beforeAll]', ->
    expect(wasBeforeAllRun).to.be.true

  it 'runs [beforeEach]', ->
    expect(beforeEachContext.test.test_case.shortName).to.equal 'runs [beforeEach]'


# --------------------------------------------------------------------------


describe 'Asynchronous tests within an "it" block', ->
  it 'is not asynchronous', ->
    expect(@isAsync).to.equal false

  it 'is asynchronous', (done) ->
    onTimeout = => done()
    Meteor.setTimeout (-> onTimeout()), 50

  it 'runs finalization within the "try" helper', ->
    onTimeout = =>
      @try ->
        done()
    Meteor.setTimeout (-> onTimeout()), 50




# --------------------------------------------------------------------------


describe.skip 'Skip suite (describe.skip)', ->
  it 'should fail', ->
    expect(true).to.equal false


describe 'Skip a test (it.skip)', ->
  it.skip 'should fail', ->
    expect(true).to.equal false

  it.skip 'should fail',
    func: ->
      expect(true).to.equal false



