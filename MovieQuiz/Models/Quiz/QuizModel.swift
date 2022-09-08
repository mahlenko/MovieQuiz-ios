//
//  Quiz.swift
//  MovieQuiz
//
//  Created by Sergey on 16.08.2022.
//

import Foundation
import UIKit

class QuizModel {
    // MARK: - Properties

    var answered = AnsweredStore()
    let beginedAt: Date
    var counterLabelText: String?
    var questions: QuestionFactoryProtocol
    var currentQuestion: QuizQuestion?
    let countAnsweredToComplete: Int = 10

    init(questions: QuestionFactoryProtocol) {
        self.beginedAt = Date()
        self.questions = questions
        self.counterLabelText = positionText()
        print("🎲 Created a new quiz and shuffled the questions.")
    }

    // MARK: - Public methods

    public func nextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let question = self.questions.requestNextQuestion() else { return }

            self.currentQuestion = question

            var imageData: Data?

            do {
                guard let url = URL(string: question.image) else { return }
                imageData = try Data(contentsOf: url)
            } catch {}

            guard let imageData = imageData else { return }
            let image = UIImage(data: imageData) ?? UIImage(named: "Error")

            let result = QuizStepViewModel(
                image: image,
                question: question.text,
                stepsTextLabel: self.positionText())

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let questions = self.questions as? QuestionIMDBFactory else { return }

                questions.delegate.didReceiveNextQuestion(question: result)
            }
        }
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
