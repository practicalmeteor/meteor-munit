suite = null


###
Defines a suite of tests.  For example:

  describe 'a suite of tests', ->
    it 'does something', ->

###
describe = (text, func) ->
  # Setup initial conditions.
  return unless _.isFunction(func)
  suite =
    name: text
    tests: {}

  # Build the set of tests within the suite.
  func()

  # Run the tests.
  Munit.run(suite)
  suite = null



###
Declares a single unit test.  For example:
###
it = (itText, func) -> suite?.tests[itText] = func if _.isFunction(func)


###
Declares the suite setup that is run before all tests within the suite.
###
beforeAll = (func) -> suite?.suiteSetup = func if _.isFunction(func)


###
Declares the test setup that is run before each test.
###
beforeEach = (func) -> suite?.setup = func if _.isFunction(func)


###
Declares the test tear-down that is run after each unit test comlete.
###
afterEach = (func) -> suite?.tearDown = func if _.isFunction(func)


###
Declares the suite tear-down that is run once after all tests are complete.
###
afterAll = (func) -> suite?.suiteTearDown = func if _.isFunction(func)



