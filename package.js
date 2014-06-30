Package.describe({
    summary: "Meteor unit testing framework for packages"
});

Package.on_use(function (api, where) {
    api.use(["coffeescript","tinytest","test-helpers","chai","sinon","underscore"]);
    api.export(['lvTestAsyncMulti']);
    api.export(['Munit']);
    api.add_files("namespaces.js");
    api.add_files("async_multi.js");
    api.add_files("Munit.coffee");
    api.add_files("Helpers.coffee");
});

Package.on_test(function(api) {
    api.use(["coffeescript","tinytest","test-helpers","chai","munit", "underscore-string-latest"]);
    api.add_files("tests/TestRunnerTest.coffee")
});
