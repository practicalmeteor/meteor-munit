describe "Helpers", ->

  it "should create a spy", ->
    spy = Munit.spies.create()
    expect(spy).to.be.ok

    spy = Munit.spies.create("spy")
    expect(spy).to.be.ok

  it "should create a stub", ->
    spy = Munit.spies.create()
    expect(spy).to.be.ok

    spy = Munit.spies.create("spy")
    expect(spy).to.be.ok

    Munit.spies.restoreAll()