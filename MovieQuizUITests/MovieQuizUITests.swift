//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Sergey on 08.10.2022.
//

import XCTest

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

    func waitFor() {
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

        waitFor()

        let indexLabel = app.staticTexts["index"]
        let secondPoster = app.images["poster"]

        XCTAssertEqual(indexLabel.label, "2 / 10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testNoButton() throws {
        let firstPoster = app.images["poster"]

        app.buttons["no"].tap()

        waitFor()

        let indexLabel = app.staticTexts["index"]
        let secondPoster = app.images["poster"]

        XCTAssertEqual(indexLabel.label, "2 / 10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testCompleteAndReload() {
        // Given
        let question_count = 10

        let buttons: [XCUIElement] = [ app.buttons["no"], app.buttons["yes"] ]

        // When
        for _ in 0..<question_count {
            buttons.randomElement()!.tap()
            waitFor()
        }

        let indexLabel = app.staticTexts["index"]
        XCTAssertTrue(indexLabel.label == "10 / 10")

        // Then
        let alert = app.alerts.firstMatch
        let alertBtn = alert.buttons.firstMatch

        XCTAssertTrue(alert.label == "🎉 Победа!" || alert.label == "Этот раунд окончен")
        XCTAssertTrue(alertBtn.label == "Попробовать еще раз")

        alertBtn.tap()
        waitFor()

        XCTAssertTrue(indexLabel.label == "1 / 10")
    }
    
}