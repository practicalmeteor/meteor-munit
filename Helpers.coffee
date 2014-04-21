# A test spy is a function that records arguments, return value,
# the value of this and exception thrown (if any) for all its calls.
# A test spy can be an anonymous function or it can wrap an existing function.
# To learn more http://sinonjs.org/docs/#spies-api
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



# Test stubs are functions (spies) with pre-programmed behavior.
# This is a wrapper for sinonjs stubs to learn more http://sinonjs.org/docs/#stubs-api
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