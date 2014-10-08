describe "Munit.spies", ->
  it "should exist", ->
    expect(Munit.spies).to.be.an 'object'
    expect(Munit.spies.restoreAll).to.be.a 'function'


describe "Munit.stubs", ->
  it "should exist", ->
    expect(Munit.stubs).to.be.an 'object'
    expect(Munit.stubs.restoreAll).to.be.a 'function'
