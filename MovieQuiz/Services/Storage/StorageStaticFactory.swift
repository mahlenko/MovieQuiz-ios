//
//  StorageStaticFactory.swift
//  MovieQuiz
//
//  Created by Sergey on 29.08.2022.
//

import Foundation

class StorageStaticFacrory: StorageFactoryProtocol {
    // MARK: - Params

    private var data: [Quiz] = []

    // MARK: - Public methods

    func all() -> [Quiz] {
        return data
    }

    func store(quiz: Quiz) {
        quiz.complete(date: Date())
        data.append(quiz)
    }

    func bestQuiz() -> Quiz? {
        guard var bestScore = data.first else { return nil }

        for score in data where score.answered.successful.count > bestScore.answered.successful.count {
            bestScore = score
        }

        return bestScore
    }
}
