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
    let networkClient: NetworkRouting

    init(client: NetworkRouting, questions: QuestionFactoryProtocol) {
        self.networkClient = client
        self.questions = questions
        self.beginedAt = Date()
        self.counterLabelText = positionText()
        print("🎲 Created a new quiz and shuffled the questions.")
    }

    // MARK: - Public methods

    public func nextQuestion(handle: @escaping (QuizStepViewModel) -> Void) {
        guard let question = self.questions.requestNextQuestion() else { return }

        self.currentQuestion = question
        self.showQuestion(handle: handle)
    }

    public func showQuestion(handle: @escaping (QuizStepViewModel) -> Void) {
        guard let question = self.currentQuestion else { return }

        self.image(imageUrl: question.image) { image in
            DispatchQueue.main.async {
                handle(QuizStepViewModel(
                    image: image,
                    question: question.text,
                    stepsTextLabel: self.positionText())
                )
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
        answered.position() == countAnsweredToComplete
    }

    public func percentAccuracy() -> Float {
        let countAnswered = answered.successful.count + answered.failed.count
        return Float(answered.successful.count) / Float(countAnswered) * 100
    }

    public func positionText() -> String {
        "\(answered.position() + 1) / \(countAnsweredToComplete)"
    }

    public func resultText() -> String {
        "\(answered.successful.count)/\(countAnsweredToComplete)"
    }

    public func isWin() -> Bool {
        answered.successful.count == countAnsweredToComplete
    }

    // MARK: - Private methods

    private func image(imageUrl: String, handle: @escaping (UIImage) -> Void) {
        guard let placeholder = defaultImage() else {
            return
        }

        guard let url = URL(string: imageUrl) else {
            return handle(placeholder)
        }

        self.networkClient.get(url: url) { result in
            switch result {
            case.success(let image):
                guard let image = UIImage(data: image) else {
                    return handle(placeholder)
                }

                handle(image)
            case .failure:
                handle(placeholder)
            }
        }
    }

    private func defaultImage() -> UIImage? {
        return UIImage(named: "Error")
    }

    private func checkAnswer(question: QuizQuestion, answer: Bool) -> Bool {
        question.correctAnswer == answer
    }
}
