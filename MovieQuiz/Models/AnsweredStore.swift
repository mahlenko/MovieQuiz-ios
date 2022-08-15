//
//  AnsweredStore.swift
//  MovieQuiz
//
//  Created by Sergey on 15.08.2022.
//

import Foundation

struct AnsweredStore {
    // MARK: - Properties

    var succesful: [QuizQuestion] = []
    var failed: [QuizQuestion] = []

    // MARK: - Public methods

    func position() -> Int {
        return succesful.count + failed.count
    }

    mutating func store(question: QuizQuestion, result: Bool) {
        result
            ? succesful.append(question)
            : failed.append(question)
    }
}
