//
//  ConvertorTest.swift
//  MovieQuizTests
//
//  Created by Sergey on 11.10.2022.
//

import XCTest

@testable import MovieQuiz

final class ConverterTest: XCTestCase {
    func testToQuestion() {
        let title = "test title movies",
            image = "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
            imDbRating = "5.6"

        let movie = MovieModel(title: title, image: image, imDbRating: imDbRating)

        let question = Converter().toQuestion(movie: movie)

        XCTAssertFalse(question.correctAnswer)
        XCTAssertEqual(question.image, image)
        XCTAssertTrue(question.text.contains(title))
        XCTAssertTrue(question.rating == Float(imDbRating))
    }
}
