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
  it 'passes the [TestCaseResults] as [this]', (args...) ->
    test = @test
    test.equal(test.test_case.shortName, 'passes the [TestCaseResults] as [this]')
    test.instanceOf(@func, Function)
    test.instanceOf(@callback, Function)





