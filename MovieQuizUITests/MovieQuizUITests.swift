//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Sergey on 08.10.2022.
//

import XCTest

// swiftlint:disable overridden_super_call implicitly_unwrapped_optional
final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }

    func waitHiddenActivityIndicator() {
        wait(
            for: [
                expectation(
                    for: NSPredicate(format: "exists == FALSE"),
                    evaluatedWith: app.activityIndicators["Destroy Indicator"]
                )
            ],
            timeout: 5
        )
    }

    func testYesButton() throws {
        let firstPoster = app.images["poster"]

        app.buttons["yes"].tap()

        waitHiddenActivityIndicator()

        let indexLabel = app.staticTexts["index"]
        let secondPoster = app.images["poster"]

        XCTAssertEqual(indexLabel.label, "2 / 10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testNoButton() throws {
        let firstPoster = app.images["poster"]

        app.buttons["no"].tap()

        waitHiddenActivityIndicator()

        let indexLabel = app.staticTexts["index"]
        let secondPoster = app.images["poster"]

        XCTAssertEqual(indexLabel.label, "2 / 10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testCompleteAndReload() {
        // Given

        // When
        for _ in 0..<10 {
            app.buttons["no"].tap()
            waitHiddenActivityIndicator()
        }

        let indexLabel = app.staticTexts["index"]
        XCTAssertTrue(indexLabel.label == "10 / 10")

        // Then
        let alert = app.alerts.firstMatch
        let alertBtn = alert.buttons.firstMatch

        XCTAssertTrue(alert.label == "🎉 Победа!" || alert.label == "Этот раунд окончен")
        XCTAssertTrue(alertBtn.label == "Сыграть еще раз" || alertBtn.label == "Попробовать еще раз")

        alertBtn.tap()
        waitHiddenActivityIndicator()

        XCTAssertTrue(indexLabel.label == "1 / 10")
    }
}
// swiftlint:enable overridden_super_call implicitly_unwrapped_optional
