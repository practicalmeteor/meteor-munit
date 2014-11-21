Package.describe({
    summary: "This package has been renamed to practicalmeteor:munit. Please use the new name instead.",
    name: "spacejamio:munit",
    version: "2.1.2",
    git: "https://github.com/practicalmeteor/meteor-munit.git"
});

Package.onUse(function (api) {
  api.versionsFrom('0.9.3');

  api.use(["coffeescript", "underscore"]);
  api.use(["tinytest","test-helpers"]);

  api.use([
    'practicalmeteor:loglevel@1.1.0_2',
    "practicalmeteor:chai@1.9.2_3",
    "practicalmeteor:sinon@1.10.3_2"]);

  api.imply(["tinytest","test-helpers"]);

  api.imply(["practicalmeteor:chai@1.9.2_3", "practicalmeteor:sinon@1.10.3_2"]);

  api.addFiles("log.js");
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
    api.use(["coffeescript", "practicalmeteor:loglevel@1.1.0_2", "practicalmeteor:munit@2.1.2"]);

    api.addFiles("tests/log.js");
    api.addFiles("tests/TDDTest.js");
    api.addFiles("tests/DescribeTest.js");
    api.addFiles("tests/TestRunnerTest.coffee");
    api.addFiles("tests/HelpersTest.coffee");
    api.addFiles("tests/DescribeTest.coffee");
});
