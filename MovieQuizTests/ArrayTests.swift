//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Sergey on 07.10.2022.
//

import XCTest

@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    // MARK: - Properties

    private let arrayTest = [1, 2, 3, 4, 5, 6, 7]

    // MARK: - Tests

    func testGetValueInRange() {
        let result = self.arrayTest[safe: 3]

        XCTAssertNotNil(result)
        XCTAssertEqual(result, 4)
    }

    func testGetValueOutOfRange() {
        let result = self.arrayTest[safe: 20]
        XCTAssertNil(result)
    }
}
