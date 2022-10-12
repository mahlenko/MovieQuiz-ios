//
//  QuestionNetworkFactoryTest.swift
//  MovieQuizTests
//
//  Created by Sergey on 07.10.2022.
//

import XCTest
@testable import MovieQuiz

final class NetworkClientTest: XCTestCase {
    // MARK: - Tests

    func testSuccessLoading() throws {
        let loader = QuestionFactory(client: StubNetworkClient(emulateError: false))

        let expectation = expectation(description: "Loading expectation")

        loader.load { result in
            switch result {
            case .success(let movies):
                // сравниваем данные с тем, что мы предполагали
                XCTAssertEqual(movies.count, 2)
                expectation.fulfill()
            case .failure:
                // проваливаем тест, в случае ошибки
                expectation.fulfill()
                XCTFail("Unexpected failure")
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testFailureLoading() throws {
        let loader = QuestionFactory(client: StubNetworkClient(emulateError: true))

        let expectation = expectation(description: "Loading expectation")

        loader.load { result in
            switch result {
            case .success:
                XCTFail("Unexpected failure")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }
}
