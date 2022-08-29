//
//  Quiz.swift
//  MovieQuiz
//
//  Created by Sergey on 16.08.2022.
//

import Foundation
import UIKit

class Quiz {
    // MARK: - Properties

    var answered = AnsweredStore()
    let beginedAt: Date
    var completedAt: Date?
    var counterLabelText: String?
    var questions: QuestionFactoryProtocol
    var currentQuestion: QuizQuestion?
    let countAnsweredToComplete: Int = 10

    init() {
        beginedAt = Date()
        questions = QuestionMockFactory()
        counterLabelText = positionText()

        print("🎲 Created a new quiz and shuffled the questions.")
    }

    // MARK: - Public methods

    public func nextQuestion() -> QuizStepViewModel? {
        guard let question = questions.requestNextQuestion() else { return nil }

        self.currentQuestion = question

        return QuizStepViewModel(
            image: UIImage(named: question.image) ?? UIImage(named: "Error"),
            question: question.text,
            stepsTextLabel: positionText())
    }

    public func checkAnswer(answer: Bool) -> Bool? {
        guard let question = currentQuestion else { return nil }

        let result = checkAnswer(question: question, answer: answer)
        answered.store(question: question, result: result)

        return result
    }

    public func isComplete() -> Bool {
        return answered.position() == countAnsweredToComplete
    }

    public func complete(date: Date) {
        self.completedAt = date
        print("🏁 Completed quiz")
    }

    public func percentAccuracy() -> Float {
        let countAnswered = answered.successful.count + answered.failed.count
        return Float(answered.successful.count) / Float(countAnswered) * 100
    }

    public func positionText() -> String {
        return "\(answered.position() + 1) / \(countAnsweredToComplete)"
    }

    public func resultText() -> String {
        return "\(answered.successful.count)/\(countAnsweredToComplete)"
    }

    public func isWin() -> Bool {
        return answered.successful.count == countAnsweredToComplete
    }

    // MARK: - Private methods

    private func checkAnswer(question: QuizQuestion, answer: Bool) -> Bool {
        return question.correctAnswer == answer
    }
}
