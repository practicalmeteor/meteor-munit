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