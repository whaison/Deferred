//
//  TaskResultTests.swift
//  DeferredTests
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright © 2014-2016 Big Nerd Ranch. Licensed under MIT.
//

import XCTest
#if SWIFT_PACKAGE
import Deferred
@testable import Result
@testable import TestSupport
#else
@testable import Deferred
#endif

class TaskResultTests: XCTestCase {
    static var allTests: [(String, (TaskResultTests) -> () throws -> Void)] {
        return [
            ("testDescriptionSuccess", testDescriptionSuccess),
            ("testDescriptionFailure", testDescriptionFailure),
            ("testDebugDescriptionSuccess", testDebugDescriptionSuccess),
            ("testDebugDescriptionFailure", testDebugDescriptionFailure),
            ("testSuccessExtract", testSuccessExtract),
            ("testFailureExtract", testFailureExtract),
            ("testCoalesceSuccessValue", testCoalesceSuccessValue),
            ("testCoalesceFailureValue", testCoalesceFailureValue),
            ("testFlatCoalesceSuccess", testFlatCoalesceSuccess),
            ("testFlatCoalesceFailure", testFlatCoalesceFailure)
        ]
    }

    private typealias Result = TaskResult<Int>

    private let aSuccessResult = Result.success(42)
    private let aFailureResult = Result.failure(TestError.first)

    func testDescriptionSuccess() {
        XCTAssertEqual(String(describing: aSuccessResult), String(42))
    }

    func testDescriptionFailure() {
        XCTAssertEqual(String(describing: aFailureResult), "first")
    }

    func testDebugDescriptionSuccess() {
        XCTAssertEqual(String(reflecting: aSuccessResult), "success(\(String(reflecting: 42)))")
    }

    func testDebugDescriptionFailure() {
        let debugDescription1 = String(reflecting: aFailureResult)
        XCTAssert(debugDescription1.hasPrefix("failure("))
        XCTAssert(debugDescription1.hasSuffix("Error.first)"))
    }

    func testSuccessExtract() {
        XCTAssertEqual(try? aSuccessResult.extract(), 42)
    }

    func testFailureExtract() {
        XCTAssertNil(try? aFailureResult.extract())
    }

    func testCoalesceSuccessValue() {
        XCTAssertEqual(aSuccessResult ?? 43, 42)
    }

    func testCoalesceFailureValue() {
        XCTAssertEqual(aFailureResult ?? 43, 43)
    }

    func testFlatCoalesceSuccess() {
        let x = aSuccessResult ?? Result.success(84)
        XCTAssertEqual(x.value, 42)
        XCTAssertNil(x.error)
    }

    func testFlatCoalesceFailure() {
        let x = aFailureResult ?? Result(success: 84)
        XCTAssertEqual(x.value, 84)
        XCTAssertNil(x.error)
    }
}
