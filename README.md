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
	
	  suiteSetup: function () {  },
	
	  setup: function () {  },
	
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
	      func: function (test, onComplete) {
	        myAsyncFunction(onComplete(function (value) {
	          test.isNotNull(value);
	        }));
	      }
	    },
	    {
	      name: "three",
	      type: "client",
	      timeout: 5000,
	      func: function (test,onComplete) {
	        test.isTrue(Meteor.isClient);
	      }
	    }
	  ],
	
	  tearDown: function () {},
	
	  suiteTearDown: function () {}
	
	}
	
	TestRunner.run(TestSuiteExample);



Create a test suite is very simple with [CoffeeScript](coffeescript.org):


	class TestSuiteExample

      name: "TestSuiteExample"

      suiteSetup: ()->

      setup: ->

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