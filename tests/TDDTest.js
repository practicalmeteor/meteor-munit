mySyncSuite = {
  name: 'mySyncSuite',

  testSyncTest: function(test){
    test.isTrue(true);
  }
};

Munit.run(mySyncSuite);

myAsyncSuite = {
  name: 'myAsyncSuite',

  testAsyncTest: function(test, waitFor){

    var onTimeout = function(){
      test.isTrue(true);
    };

    Meteor.setTimeout(waitFor(onTimeout), 50);
  }
};

Munit.run(myAsyncSuite);

tddTestSuite = {

  name: "TDD test suite",

  suiteSetup: function () {
    // Let's do 'cleanup' in suiteSetup too, in case another suite didn't clean up properly
    spies.restoreAll();
    stubs.restoreAll();
    console.log("I'm suiteSetup");
  },

  setup: function () {
    console.log("I'm setup");
    spies.create('log', console, 'log');
  },

  tearDown: function () {
    spies.restoreAll();
    console.log("I'm tearDown");
  },

  suiteTearDown: function () {
    console.log("I'm suiteTearDown");
    spies.restoreAll();
    stubs.restoreAll();
  },

  testSpies: function (test) {
    console.log('Hello world');
    expect(spies.log).to.have.been.calledWith('Hello world');
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
      name: "skipped client test",
      type: 'client',
      skip: true,
      func: function (test) {
        test.isTrue(true)
      }
    },
    {
      name: "async test with timeout",
      timeout: 500,
      func: function (test, waitFor) {
        var onTimeout = function(){
          test.isTrue(true);
        };

        Meteor.setTimeout(waitFor(onTimeout), 50);
      }
    }
  ]
};

Munit.run(tddTestSuite);
