_suite = null




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
  if _suite?
    # NOTE: Change this if it turns out we can test suites within suites.
    _suite = null # Reset the suite.
    throw new Error('Cannot nest "describe" statements')

  # Build the set of tests within the suite.
  _suite = result =
    name: text
    tests: {}
  func()
  _suite = null

  # Run the tests.
  Munit.run(result) if describe.autoRun is true

  # Finish up.
  result



###
Flag used to set whether test declarations are automatically
passed into the [run] function of Munit.

  NB: Used internally for testing.

###
describe.autoRun = true




###
Declares a single unit test.
###
it = (text, func) -> _suite?.tests[text] = wrap(func) if _.isFunction(func)


###
Declares the suite setup that is run before all tests within the suite.
###
beforeAll = (func) -> _suite?.suiteSetup = wrap(func) if _.isFunction(func)


###
Declares the test setup that is run before each test.
###
beforeEach = (func) -> _suite?.setup = wrap(func) if _.isFunction(func)


###
Declares the test tear-down that is run after each unit test comlete.
###
afterEach = (func) -> _suite?.tearDown = wrap(func) if _.isFunction(func)


###
Declares the suite tear-down that is run once after all tests are complete.
###
afterAll = (func) -> _suite?.suiteTearDown = wrap(func) if _.isFunction(func)



# PRIVATE --------------------------------------------------------------------------

wrap = (func) ->
  (test, callback) ->
    self =
      test: test
      callback: callback
      func: func

    func.call(self, callback)



