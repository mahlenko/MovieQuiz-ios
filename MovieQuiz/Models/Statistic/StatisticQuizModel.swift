//
//  AnsweredStore.swift
//  MovieQuiz
//
//  Created by Sergey on 15.08.2022.
//

import Foundation

struct StatisticQuizModel {
    // MARK: - Properties

    private(set) var successful: [QuestionModel] = []
    private(set) var failure: [QuestionModel] = []

    // MARK: - Public methods

    mutating func reset() {
        successful.removeAll()
        failure.removeAll()
    }

    func resultText() -> String {
        let totalAnswers = successful.count + failure.count
        return "\(successful.count) / \(totalAnswers)"
    }

    func position() -> Int {
        successful.count + failure.count
    }

    func positionText(total: Int) -> String {
        "\(position() + 1) / \(total)"
    }

    func average() -> Float {
        let answers = Float(successful.count + failure.count)
        return Float(successful.count) / answers * 100
    }

    mutating func store(question: QuestionModel, result: Bool) {
        if result {
            successful.append(question)
        } else {
            failure.append(question)
        }
    }
}
