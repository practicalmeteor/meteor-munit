Package.describe({
    summary: "Meteor unit testing framework for packages"
});

Package.on_use(function (api, where) {
    api.use(["coffeescript","tinytest","test-helpers","chai","sinon","underscore"]);
    api.export(['lvTestAsyncMulti']);
    api.export(['TestRunner']);
    api.add_files("namespaces.js");
    api.add_files("async_multi.js");
    api.add_files("TestRunner.coffee");
    api.add_files("Helpers.coffee");
});

Package.on_test(function(api) {
    api.use(["coffeescript","tinytest","test-helpers","chai","munit"]);
//    api.add_files("tests/TestSuiteTest.coffee")
    api.add_files("tests/TestRunnerTest.coffee")
});
