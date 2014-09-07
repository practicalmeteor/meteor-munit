Helper = (helper)->

  _objs: {}

  create: (name, obj, method)->
    expect(name).to.be.a("string")
    expect(obj).to.be.an("object")
    expect(method).to.be.a("string")
    restore name if @_objs[name]
    @_objs[name] = sinon[helper](obj, method)
    return @_objs[name]

  get: (name)->
    @_objs[name]

  restore:(name)->
    if not @_objs[name]
      console.warn "Trying to restore a non-exising #{helper} with name: #{name}"
      return

    @_objs[name].restore()
    delete @_objs[name]


  restoreAll: ->
    for key of @_objs
      @restore(key)

# A test spy is a function that records arguments, return value,
# the value of this and exception thrown (if any) for all its calls.
# A test spy can be an anonymous function or it can wrap an existing function.
# To learn more http://sinonjs.org/docs/#spies-api

Munit.spies = Helper("spy");


# Test stubs are functions (spies) with pre-programmed behavior.
# This is a wrapper for sinonjs stubs to learn more http://sinonjs.org/docs/#stubs-api
Munit.stubs = Helper("stub");