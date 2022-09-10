//
//  AnsweredStore.swift
//  MovieQuiz
//
//  Created by Sergey on 15.08.2022.
//

import Foundation

struct AnsweredStore {
    // MARK: - Properties

    private(set) var successful: [QuizQuestion] = []
    private(set) var failed: [QuizQuestion] = []

    // MARK: - Public methods

    func position() -> Int {
        return successful.count + failed.count
    }

    mutating func store(question: QuizQuestion, result: Bool) {
        result ? successful.append(question) : failed.append(question)
    }
}
