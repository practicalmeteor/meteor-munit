suite = null




###
Defines a suite of tests.  For example:

  describe 'a suite of tests', ->
    it 'does something', ->

@param text: The describe text for the suite.
@param func: The test function to run.
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
  Munit.run(suite) if describe.autoRun is true

  # Finish up.
  suite
  # suite = null



###
Flag used to set whether test declarations are automatically
passed into the [run] function of Munit.

  NB: Used internally for testing.

###
describe.autoRun = true





###
Declares a single unit test.
###
it = (text, func) -> suite?.tests[text] = func if _.isFunction(func)


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



