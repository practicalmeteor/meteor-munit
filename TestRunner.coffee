class spacejam.munit


  @run:(testSuite)->
    chai.expect(testSuite).to.be.an('object')

    suiteName = testSuite.name || testSuite.constructor.name
    suiteSetup = _getSuiteFunction(testSuite,'suiteSetup')
    suiteTearDown = _getSuiteFunction(testSuite,'suiteTearDown')
    testSetup = _getSuiteFunction(testSuite,"setup")
    testTearDown = _getSuiteFunction(testSuite,"tearDown")
    arrSuiteTests = _getSuiteTests(testSuite)

    if arrSuiteTests.length is 0
      return

    firstTest = arrSuiteTests.shift() # get first element of an array
    lastTest = arrSuiteTests.pop()# get last element of an array

    addFirstTest = ->
      lvTestAsyncMulti "#{suiteName} - #{firstTest.name}",firstTest.timeout,[
        suiteSetup
        testSetup
        firstTest.func
        testTearDown
      ]

    addLastTest = ->
      lvTestAsyncMulti "#{suiteName} - #{lastTest.name}",lastTest.timeout,[
        testSetup
        lastTest.func
        testTearDown
        suiteTearDown
      ]

    if firstTest and not lastTest
      lvTestAsyncMulti "#{suiteName} - #{firstTest.name}",firstTest.timeout,[
        suiteSetup
        testSetup
        firstTest.func
        testTearDown
        suiteTearDown
      ]
    else if firstTest and lastTest and arrSuiteTests.length is 0
      addFirstTest()
      addLastTest()

    else
      addFirstTest()
      for test in arrSuiteTests
        lvTestAsyncMulti "#{suiteName} - #{test.name}",test.timeout,[
          testSetup
          test.func
          testTearDown
        ]
      addLastTest()


  _getSuiteFunction = (testSuite,nameFunc)->
    func = testSuite[nameFunc]
    return func ?= -> # create an empty function if no exists

  _getSuiteTests = (testSuite)->
    arrTests = []
    suiteTests = testSuite['tests']
    if suiteTests
      chai.expect(suiteTests).to.be.an('array')
      for test in suiteTests
        chai.expect(test).to.have.property('name')
        chai.expect(test).to.have.property('func')
        if not test.skip
          test.timeout = test.timeout || 5000
          if test.type is "client"
            if Meteor.isClient
              arrTests.push test
          else if test.type is "server"
            if Meteor.isServer
              arrTests.push test
          else
            arrTests.push test

    for key,func of testSuite
      if key isnt "tests" and key.indexOf("test") is 0
        expect(func).to.be.a('function')
        arrTests.push name:key,func:func,timeout:5000

      else if key.indexOf("clientTest") is 0
        if Meteor.isClient
          expect(func).to.be.a('function')
          suiteTestName = key.replace("client","")
          arrTests.push name:suiteTestName,func:func,timeout:5000

      else if key.indexOf("serverTest") is 0
        if Meteor.isServer
          expect(func).to.be.a('function')
          suiteTestName = key.replace("server","")
          arrTests.push name:suiteTestName,func:func,timeout:5000

    return arrTests
