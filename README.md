MUnit
========================

**MUnit** stands for Meteor Unit Test.

Installation
========================
``mrt add munit``


Creating tests
========================
**MUnit** uses test suites to run tests. Each test suite can have the following properties.

* `suiteSetup`: runs once before any test
* `setup`: runs before each test
* `suiteTearDown`: run after the last test
* `tearDown`: runs after each test
* `tests`: an array of tests cases
* `test<Name>` any function prefixed with `test` will run as a test case
* `clientTest<Name>` same as above will only run on client
* `serverTest<Name>` same as above will only run on server


The tests cases can have this properties:

* `name`: the name of test case (**required**)
* `type`: where to run the tests either `client` or `server`
* `timeout`: test timeout. Default 5000
* `skip`: ignore assertions of the test
* `func`: your tests goes here (**required**)


Example Test Suite
---------------------------
	
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
	
	  testIsValid: function (test) {
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
	      name: "three",
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
	
	TestRunner.run(TestSuiteExample);



Create a test suite is very simple with [CoffeeScript](coffeescript.org):


	class TestSuiteExample
	
	  name: "TestSuiteExample"
	
	  suiteSetup: ()->
	
	  setup: ->
	
	  testAsync: (test, done) ->
	    myAsyncFunction done((value) ->
	      test.isNotNull value
	    )
	
	  testIsValid: (test) ->
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
	      name: "three"
	      type: "client"
	      timeout: 5000
	      func: (test)->
	        test.isTrue Meteor.isClient
	    }
	  ]
	
	  tearDown: ->
	
	  suiteTearDown: ->
	
	TestRunner.run(new TestSuiteExample())






Contributions
----------------------------
Contributions are more than welcome. Just create pull requests.
