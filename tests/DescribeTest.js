describe('suite1', function(){
  beforeAll(function (test){
    // Let's do 'cleanup' beforeEach too, in case another suite didn't clean up properly
    spies.restoreAll();
    stubs.restoreAll();
    log.info("I'm beforeAll");
  });
  beforeEach(function (test){
    log.info("I'm beforeEach");
    spies.create('log', console, 'log');
  });
  afterEach(function (test){
    spies.restoreAll();
    log.info("I'm afterEach");
  });
  afterAll(function (test){
    log.info("I'm afterAll");
    spies.restoreAll();
    stubs.restoreAll();
  });
  it('test1', function(test){
    console.log('Hello world');
    expect(spies.log).to.have.been.calledWith('Hello world');
  })
});

describe('suite2', function(){
  it('async test', function(test, waitFor){
    var onTimeout = function () {
      try {
        expect(true).to.be.true;
      } catch(err) {
        test.exception(err);
      }
    };
    Meteor.setTimeout(waitFor(onTimeout), 50);
  });
});


describe.skip('skipped suite', function(){
  it('work in progress', function(test){
    expect(false).to.be.true;
  });
});

describe('suite with skipped test', function(){
  it.skip('skipped test', function(test){
    expect(false).to.be.true;
  });
});

describe('client only and server only tests', function(){
  it.client('runs only in client', function(test){
    expect(Meteor.isClient).to.be.true;
  });
  it.server('runs only in server', function(test){
    expect(Meteor.isServer).to.be.true;
  });
});

describe.client('client only test suite', function(){
  it('runs only in client', function(test){
    expect(Meteor.isClient).to.be.true;
  });
  it.server('overrides describe.client and runs only in server', function(test){
    expect(Meteor.isServer).to.be.true;
  });
});

describe.server('server only test suite', function(){
  it('runs only in server', function(test){
    expect(Meteor.isServer).to.be.true;
  });
  it.client('overrides describe.server and runs only in client', function(test){
    expect(Meteor.isClient).to.be.true;
  });
});

describe('top-level describe', function(){
  describe('nested describe', function() {
    describe('deep nested describe', function() {
      it('a test', function (test) {
        expect(true).to.be.true;
      })
    })
  })
});
