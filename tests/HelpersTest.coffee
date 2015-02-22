describe "Munit.spies", ->
  it "should exist", ->
    expect(Munit.spies).to.be.an 'object'
    expect(Munit.spies.restoreAll).to.be.a 'function'


describe "Munit.stubs", ->
  it "should exist", ->
    expect(Munit.stubs).to.be.an 'object'
    expect(Munit.stubs.restoreAll).to.be.a 'function'


describe "Munit.wrap", ->
  it "should set Munit.lastError to the thrown exception", ->
    fn = (msg)->
      throw new Error(msg)

    expect(Munit.wrap(->fn("wrapped"))).to.throw(Error, 'wrapped')
    expect(Munit.lastError).to.be.instanceof Error
    expect(Munit.lastError.message).to.equal 'wrapped'


describe "Munit.wrap", ->
  it "should set Munit.lastError to null if not excpetion was thrown", ->
    fn = (msg)->
      return

    expect(Munit.wrap(->fn("wrapped"))).to.not.throw()
    expect(Munit.lastError).to.be.null

