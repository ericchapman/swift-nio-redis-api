import XCTest

import RedisApiTests

var tests = [XCTestCaseEntry]()
tests += RedisApiTests.allTests()
XCTMain(tests)
