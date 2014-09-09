#TODO: Write proper tests...

class A
  echo: (text) ->
    console.log 'hello'
    return text

  returnString: (string) ->

a = new A()

describe "Spies", ->

  it "should create a spy and restore it", ->
    spy = Munit.spies.create("echoSpy", a, 'echo')
    expect(spy).to.contain.key 'restore'
    expect(Munit.spies.get('echoSpy')).to.contain.key 'restore'
    Munit.spies.restore('echoSpy')
    expect(Munit.spies.get('echoSpy')).to.be.undefined



describe "Stubs", ->
  it "should create a stub and restore it", ->
    stub = Munit.stubs.create("echoStub", a, 'echo')
    expect(stub).to.contain.key 'restore'
    expect(Munit.stubs.get('echoStub')).to.contain.key 'restore'
    Munit.stubs.restore('echoStub')
    expect(Munit.stubs.get('echoStub')).to.be.undefined
