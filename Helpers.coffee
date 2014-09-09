class Munit.SinonObjects
  _objs: {}

  get: (name)->
    return @_objs[name]

  restore:(name)->
    if not @_objs[name]
      console.warn "Trying to restore a non-existing spy/stub with name: #{name}"
      return

    @_objs[name].restore?()
    delete @_objs[name]
    return

  restoreAll: ->
    for key of @_objs
      @restore key


class Munit.SinonSpies extends Munit.SinonObjects
  create: (name, obj, method)->
    expect(name).to.be.a("string")
    if not obj and not method
      # Creates an anonymous function that records arguments, this value, exceptions and return values for all calls.
      return @_objs[name] = sinon.spy()

    if not method
      expect(obj).to.be.a("function")
      return @_objs[name] = sinon.spy(obj)

    expect(obj).to.be.an "object"
    expect(method).to.be.a "string"
    if @_objs[name]
      @restore name
    spy = sinon.spy(obj, method)
    @_objs[name] = spy
    return spy



class Munit.SinonStubs extends Munit.SinonObjects
  create: (name, obj, method)->
    expect(name).to.be.a("string")
    if not obj and not method
      return @_objs[name] = sinon.stub()

    expect(obj).to.be.an("object")
    expect(method).to.be.a("string")
    if @_objs[name]
      @restore name
    return @_objs[name] = sinon.stub(obj, method)


# A test spy is a function that records arguments, return value,
# the value of this and exception thrown (if any) for all its calls.
# A test spy can be an anonymous function or it can wrap an existing function or object method.
# To learn more http://sinonjs.org/docs/#spies-api

Munit.spies = new Munit.SinonSpies()


# Test stubs are functions (spies) with pre-programmed behavior.
# This is a wrapper for sinonjs stubs to learn more http://sinonjs.org/docs/#stubs-api
Munit.stubs = new Munit.SinonStubs()
