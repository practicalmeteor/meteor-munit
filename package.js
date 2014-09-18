Package.describe({
    summary: "Meteor unit testing framework for packages",
    name: "spacejamio:munit",
    version: "0.2.1",
    git: "https://github.com/spacejamio/meteor-munit.git"
});

Package.on_use(function (api, where) {
  api.use(["coffeescript","tinytest","test-helpers","underscore"]);

  api.use(["spacejamio:chai@0.1.6","spacejamio:sinon@0.1.6"]);

  api.add_files("namespaces.js");
  api.add_files("async_multi.js");
  api.add_files("Munit.coffee");
  api.add_files("Helpers.coffee");
  api.add_files("Describe.coffee");

  api.export(['lvTestAsyncMulti']);
  api.export(['Munit', 'chai']);
  api.export(['describe', 'it', 'beforeAll', 'beforeEach', 'afterEach', 'afterAll']);
});

Package.on_test(function(api) {
    api.use(["coffeescript" ,"tinytest" ,"test-helpers", "spacejamio:munit"]);
    api.add_files("tests/TestRunnerTest.coffee");
    api.add_files("tests/HelpersTest.coffee");
    api.add_files("tests/DescribeTest.coffee");
});
