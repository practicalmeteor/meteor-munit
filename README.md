Munit
========================

**Munit** stands for meteor unit (tests). It is a wrapper around Tinytest, the package testing framework shipped with meteor. **Munit** adds support for test suites and some additional functionality that is standard in other testing frameworks, such as test timeouts, setup, tearDown, suiteSetup, and suiteTearDown.

For additional information regarding Tinytest, please refer to this excellent screencast from the guys at EventedMind: [Testing Packages with Tinytest](https://www.eventedmind.com/feed/meteor-testing-packages-with-tinytest
)

Installation
========================
``mrt add munit``


## Declaring Tests with BDD Semantics
MUnit also allows you to use `describe` and `it` declaration blocks to declare tests:


```coffeescript

describe 'My test suite', ->

  beforeAll ->  # Runs once before all tests within the suite (suiteSetup.
  beforeEach -> # Runs before each test (setup).

  it 'does something', ->
    expect(true).to.equal true

  afterEach -> # Runs after each test (tearDown).
  afterAll ->  # Runs after all tests (suiteTearDown)

```

To run a test asynchronously include a `done` callback, and invoke it upon completion:

```coffeescript

describe 'My test suite', ->
  it 'does something asynchronously', (done) ->

    onComplete = ->
      expect(true).to.equal true
      done()

    Meteor.setTimeout (-> onComplete()), 1000

```


**NOTE**: This callback behavior works the way Mocha handles callbacks within BDD style tests
and differs from the way MUnit suites handle asynchronous tests.


### Skipping Tests

```coffeescript

describe.skip 'My suite', ->
  it 'should fail', ->
    expect(true).to.equal false


describe 'My suite', ->
  it.skip 'should fail', ->
    expect(true).to.equal false

```

### Specifying Execution Domain
You can optionally declare on both the `describe` and `it` statements whether
the code should be executed on the `client` or the `server`.
By default specs execute on both `client` and `server`.

Specifying execution domain on the `it` statement:


```coffeescript

describe.client 'My suite', ->
  it.client 'runs on the client only', ->
    # ...

  it.server 'runs on the server only', ->
    # ...

```


Specifying execution domain on the `describe` statement:

```coffeescript

describe.client 'All tests within the suite run on the client', ->
  it 'runs on the client only', ->
    # ...

  it.server 'overrides parent "describe.client" and runs on the server', ->
    # ...




describe.server 'All tests within the suite run on the server', ->
  it 'runs on the server only', ->
    # ...

  it.client 'overrides parent "describe.server" and runs on the client', ->
    # ...


```





Creating Test Suites
========================
With **Munit**, you organize your tests into test suite objects (or CoffeeScript classes). Each test suite can have the following methods and properties.

* `name`: the test suite name, with support for dashes for sub-grouping, as in Tinytest
* `suiteSetup`: runs once before all tests
* `suiteTearDown`: runs once after all tests
* `setup`: runs before each test
* `tearDown`: runs after each test
* `tests`: an array of test cases, in the format below, OR:
* `test<Name>` any function prefixed with `test` will run as a test case
* `clientTest<Name>` same as above, but will only run in the browser
* `serverTest<Name>` same as above, but will only run on the server

The test cases in the array of `tests`, can have the following properties:

* `name`: the name of the test case (**required**)
* `func`: the test case function (**required**)
* `type`: where to run the tests, either `client` or `server`. If doesn't exist, runs on both
* `timeout`: test timeout, in milliseconds (**default 5000**)
* `skip`: skip the test

To run your test suite tests, just:

`Munit.run( yourTestSuiteObject );`


Writing Tests
========================
	mySuite = {
		testExample:function(test){
			test.isTrue(true)
		}
	}

The `test` argument is the same test object passed to a test function by `Tinytest.add`, and has the following methods:

* `equal(actual, expected, msg)`
* `notEqual(actual, expected, msg)`
* `instanceOf(obj, klass)`
* `matches(actual, regexp, msg)`
* `throws(func, expected)`
* `isTrue(value, msg)`
* `isFalse(value, msg)`
* `isNull(value, msg)`
* `isNotNull(value, msg)`
* `isUndefined(value, msg)`
* `isNaN(value, msg)`
* `include(object, key)`
* `include(string, substring)`
* `include(array, value)`
* `length(obj, expected_length, msg)`

The `msg` property is a custom error message for the assertion.

You can see the source code [here](https://github.com/meteor/meteor/blob/devel/packages/tinytest/tinytest.js).

In addition munit depends on:

1. The excellent [chai](https://atmospherejs.com/package/chai) BDD / TDD assertion library that we wrapped for meteor, so you can use all it's goodies exported into:

 * expect
 * assert
 * should


2. The excellent [sinon](https://atmospherejs.com/package/sinon) test spies, stubs and mocks JavaScript library, wrapped for meteor:

Writting Async Tests
==
    myAsyncFunction = function(callback){
       setTimeout(function(){
         callback(true)
       },1000)
    }

    mySuite = {
      testExample: function (test, done) {
        myAsyncFunction(done(function (value) {
          test.isNotNull(value);
        }));
      }
    }

The `done` argument is the `onComplete` function passed to a test function by `Tinytest.addAsync`.

JavaScript Example
========================

	TestSuiteExample = {

	  name: "TestSuiteExample",

	  suiteSetup: function () {
	  },

	  setup: function () {
	  },

	  testAsync: function (test,done) {
	    myAsyncFunction(done(function (value) {
	      test.isNotNull(value);
	    }));
	  },

	  testIsTrue: function (test) {
	    test.isTrue(true);
	  },

	  clientTestIsClient: function (test) {
	    test.isTrue(Meteor.isClient);
	    test.isFalse(Meteor.isServer);
	  },

	  serverTestIsServer: function(test){
	    test.isTrue(Meteor.isServer);
	    test.isFalse(Meteor.isClient);
	  },

	  tests: [
	    {
	      name: "sync test",
	      func: function (test) {
	        test.isTrue(true)
	      }
	    },
	    {
	      name: "async test",
	      skip: true,
	      func: function (test, done) {
	        myAsyncFunction(done(function (value) {
	          test.isNotNull(value);
	        }));
	      }
	    },
	    {
	      name: "test with timeout",
	      type: "client",
	      timeout: 5000,
	      func: function (test) {
	        test.isTrue(Meteor.isClient);
	      }
	    }
	  ],

	  tearDown: function () {
	  },

	  suiteTearDown: function () {
	  }

	}

	Munit.run(TestSuiteExample);



#[CoffeeScript](coffeescript.org) Example

```coffeescript


class TestSuiteExample

  name: "TestSuiteExample"

  suiteSetup: ->

  setup: ->

  testAsync: (test, done) ->
    myAsyncFunction done((value) ->
      test.isNotNull value
    )

  testIsTrue: (test) ->
    test.isTrue true

  clientTestIsClient: (test) ->
    test.isTrue Meteor.isClient
    test.isFalse Meteor.isServer

  serverTestIsServer: (test) ->
    test.isTrue Meteor.isServer
    test.isFalse Meteor.isClient

  tests: [
    {
      name: "sync test"
      func: (test)->

    },
    {
      name: "async test"
      skip: true
      func: (test, done)->
        myAsyncFunction done((value)->
          test.isNotNull(value)
        )

    },
    {
      name: "test with timeout"
      type: "client"
      timeout: 5000
      func: (test)->
        test.isTrue Meteor.isClient
    }
  ]

  tearDown: ->

  suiteTearDown: ->

Munit.run(new TestSuiteExample())

```


## Declaring Tests as an Object.
Alternatively you can declare the `tests` as an object, for example:


```coffeescript

class TestSuiteExample
	name: "TestSuiteExample"

	tests:
	  myTest1: (test) -> # Name parsed to "My Test 1"

	  myTest2:
	    skip: true
	    func: (test) -> # Name parsed to "My Test 2"

```


Sample Meteor App
-------
Provided thanks to Michael Risse:

https://github.com/rissem/meteor-munit-example/

See the lib package munit tests here, including how to add your tests to your package.js:

https://github.com/rissem/meteor-munit-example/tree/master/packages/lib

Running your package tests in the browser with hot code reloads
----------------
Assuming you develop your package as part of a meteor app and the package is located
in the packages folder, from the meteor app root, run:

`meteor test-packages package-name OR path-to-your-package [more packages]`

Then, just open your browser at the same url you use for your meteor app and the tests
will start running automatically, including re-run on every code change.

You can specify more than one package to test. Without arguments, it will test all packages in the packages folder, including the meteor and meteorite ones.

If you develop your package stand-alone, make sure meteor is in your path, and run:

`meteor test-packages path-to-your-package`


Running your meteor app and your meteor package tests at the same time
----------------
The way we work internally is to run our meteor app with a free [mongohq](http://www.mongohq.com/)  sandbox database and at the same time run all of our packages tests with the internal meteor mongodb on a different port:

* app: `MONGO_URL=... meteor`
* tests: `meteor --port 3100 test-packages our-packages`

For our convenience, we created a couple of shell scripts that use environment variables that we set in our .bashrc to run the app and the tests. We recommend you do the same.


Internals
----------------
The **Munit** test runner uses a slightly modified version of the `testAsyncMulti` function (with support for test timeouts) from the  test-helpers package shipped with meteor to run all the tests in the test suite including all the setup and `tearDown` functions, and therefore you will see the `setup` and `tearDown` functions as separate test cases in the test output.

Contributions
----------------
Contributions are more than welcome. Just create pull requests. Some of the things we think may be valuable are:

* A file loader that automatically calls `Munit.run( testSuiteObject );`
* A script that converts a meteor app into a meteor package, automatically creating the package.js file according to the meteor gathering order.


License
--------
MIT
