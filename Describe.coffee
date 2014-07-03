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
Declares a suite to be skipped.
###
describe.skip = (text, func) ->
  # No-op.
  # Report that the suite is being skipped, and to not
  # pass it in.
  console.log "SKIPPING SUITE: #{ text }"



# IT --------------------------------------------------------------------------



###
Declares a unit test.
@param text:      The description of the test.
@param func:      The test function.
###
it = (text, func) ->
  if _suite? and _.isFunction(func)
    func = wrap(func)
    _suite.tests[text] = { func:func }


###
Declares a unit test to be skipped.
###
it.skip = (text, func) ->
  if _suite?
    console.log "SKIPPING SUITE: #{ _suite.name } >> TEST: #{ text }"


###
Declares a unit test to run only on the client.
@param text:      The description of the test.
@param func:      The test function.
###
it.client = (text, func) ->
  if _suite?
    def = it(text, func)
    def.type = 'client'
    def


###
Declares a unit test to run only on the server.
@param text:      The description of the test.
@param func:      The test function.
###
it.server = (text, func) ->
  if _suite?
    def = it(text, func)
    def.type = 'server'
    def



it.client.skip = it.skip
it.server.skip = it.skip



# SETUP / TEARDOWN --------------------------------------------------------------------------



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
  suite   = _suite
  params  = getParamNames(func)
  isAsync = params.length > 0

  (test, callback) ->
      self =
        suite:    suite
        test:     test
        callback: callback
        func:     func
        isAsync:  isAsync

        ###
        Use this to invoke assertions after a callback so that
        errors will be reported in the test runner.
        ###
        try: (func) ->
          try
            func() if _.isFunction(func)
          catch error
            test.onException(error)

      if isAsync
        invokeAsync = (done) -> func.call self, (-> done())
        invokeAsync callback ->

      else
        func.call(self)


# See: http://stackoverflow.com/questions/1007981/how-to-get-function-parameter-names-values-dynamically-from-javascript

STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg
ARGUMENT_NAMES = /([^\s,]+)/g
getParamNames = (func) ->
  fnStr = func.toString().replace(STRIP_COMMENTS, '')
  result = fnStr.slice(fnStr.indexOf('(')+1, fnStr.indexOf(')')).match(ARGUMENT_NAMES)
  result = [] if result is null
  result

