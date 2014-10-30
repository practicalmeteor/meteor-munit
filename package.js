Package.describe({
    summary: "Meteor unit testing framework for packages",
    name: "spacejamio:munit",
    version: "2.1.0",
    git: "https://github.com/spacejamio/meteor-munit.git"
});

Package.onUse(function (api) {
  api.versionsFrom('0.9.3');

  api.use(["coffeescript", "underscore"]);
  api.use(["tinytest","test-helpers"]);

  api.use([
    'spacejamio:loglevel@1.1.0_1',
    "spacejamio:chai@1.9.2_2",
    "spacejamio:sinon@1.10.3_1"]);

  api.imply(["tinytest","test-helpers"]);

  api.imply(["spacejamio:chai@1.9.2_2", "spacejamio:sinon@1.10.3_1"]);

  api.addFiles("namespaces.js");
  api.addFiles("async_multi.js");
  api.addFiles("Munit.coffee");
  api.addFiles("Helpers.coffee");
  api.addFiles("Describe.coffee");

  api.export(['lvTestAsyncMulti']);
  api.export(['Munit']);
  api.export(['describe', 'it', 'beforeAll', 'beforeEach', 'afterEach', 'afterAll']);
});

Package.onTest(function(api) {
    api.use(["coffeescript", "spacejamio:loglevel@1.1.0_1", "spacejamio:munit"]);

    api.addFiles("tests/TDDTest.js");
    api.addFiles("tests/DescribeTest.js");
    api.addFiles("tests/TestRunnerTest.coffee");
    api.addFiles("tests/HelpersTest.coffee");
    api.addFiles("tests/DescribeTest.coffee");
});
