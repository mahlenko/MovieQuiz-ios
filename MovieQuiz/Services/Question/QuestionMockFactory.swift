//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Sergey on 15.08.2022.
//

import Foundation

class QuestionMockFactory: QuestionFactoryProtocol {
    // MARK: - Properties

    private let questions: [QuizQuestion] = [
        QuizQuestion.init(
            image: "The Godfather",
            rating: 9.2,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),

        QuizQuestion.init(
            image: "The Dark Knight",
            rating: 9.0,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),

        QuizQuestion.init(
            image: "Kill Bill",
            rating: 8.1,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),

        QuizQuestion.init(
            image: "The Avengers",
            rating: 8.0,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),

        QuizQuestion.init(
            image: "Deadpool",
            rating: 8.0,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),

        QuizQuestion.init(
            image: "The Green Knight",
            rating: 6.6,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),

        QuizQuestion.init(
            image: "Old",
            rating: 5.8,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),

        QuizQuestion.init(
            image: "The Ice Age Adventures of Buck Wild",
            rating: 4.3,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),

        QuizQuestion.init(
            image: "Tesla",
            rating: 5.1,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),

        QuizQuestion.init(
            image: "Vivarium",
            rating: 5.8,
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]

    // MARK: - Public methods

    func requestNextQuestion() -> QuizQuestion? {
        let index = (0..<questions.count).randomElement() ?? 0
        return questions[safe: index]
    }
}
