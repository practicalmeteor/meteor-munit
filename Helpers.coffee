class Stubs

  stubs = {}

  @create:(name,obj,method)->
    expect(name).to.be.a("string")
    expect(obj).not.to.be.null
    expect(method).to.be.a("string")
    stubs[name] ?= sinon.stub(obj,method)
    return stubs[name]


  @get:(name)->
    stubs[name]

  @restore:(name)->
    stubs[name]?.restore()

spacejam.munit.stubs = Stubs

class Spies

  spies = {}

  @create:(name,obj,method)->
    expect(name).to.be.a("string")
    expect(obj).to.be.an("object")
    expect(method).to.be.a("string")
    spies[name] ?= sinon.spy(obj,method)
    return spies[name]


  @get:(name)->
    spies[name]


  @restore:(name)->
    spies[name]?.restore()

spacejam.munit.spies = Spies