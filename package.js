Package.describe({
    summary: "Meteor unit testing framework for packages",
    name: "practicalmeteor:munit",
    version: "2.1.5",
    git: "https://github.com/practicalmeteor/meteor-munit.git"
});

Package.onUse(function (api) {
  api.versionsFrom('0.9.3');

  api.use(["coffeescript", "underscore"]);
  api.use(["tinytest","test-helpers"]);

  api.use([
    'practicalmeteor:loglevel@1.2.0_1',
    "practicalmeteor:chai@2.1.0_1",
    "practicalmeteor:sinon@1.14.1_2"]);

  api.imply(["tinytest","test-helpers"]);

  api.imply([
      'practicalmeteor:loglevel@1.2.0_1',
      "practicalmeteor:chai@2.1.0_1",
      "practicalmeteor:sinon@1.14.1_2"
  ]);

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
    api.use(["coffeescript", "practicalmeteor:munit@2.1.5"]);

    api.addFiles("tests/log.js");
    api.addFiles("tests/TDDTest.js");
    api.addFiles("tests/DescribeTest.js");
    api.addFiles("tests/TestRunnerTest.coffee");
    api.addFiles("tests/HelpersTest.coffee");
    api.addFiles("tests/DescribeTest.coffee");
});
