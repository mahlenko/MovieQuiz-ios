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
    var questions: QuestionFactory
    var currentQuestion: QuizQuestion?
    let countAnsweredToComplete: Int = 10

    init() {
        beginedAt = Date()
        questions = QuestionFactory()
        counterLabelText = getTextForStepsLabel()

        print("🎲 Created a new quiz and shuffled the questions.")
    }

    // MARK: - Public methods

    func nextQuestion() -> QuizStepViewModel? {
        guard let question = questions.requestNextQuestion() else { return nil }
        self.currentQuestion = question

        return QuizStepViewModel(
            image: UIImage(named: question.image) ?? UIImage(named: "Error"),
            question: question.text,
            stepsTextLabel: getTextForStepsLabel())
    }

    func checkAnswer(answer: Bool) -> Bool? {
        guard let question = currentQuestion else { return nil }

        let result = checkAnswer(question: question, answer: answer)
        answered.store(question: question, result: result)

        return result
    }

    func isComplete() -> Bool {
        return answered.position() == countAnsweredToComplete
    }

    func complete(date: Date) {
        self.completedAt = date
        print("🏁 Completed quiz")
    }

    func percentAccuraty() -> Float {
        let countAnswered = answered.succesful.count + answered.failed.count
        return Float(answered.succesful.count) / Float(countAnswered) * 100
    }

    // MARK: - Private methods

    private func checkAnswer(question: QuizQuestion, answer: Bool) -> Bool {
        return question.correctAnswer == answer
    }

    private func getTextForStepsLabel() -> String {
        return "\(answered.position() + 1) / \(countAnsweredToComplete)"
    }
}
