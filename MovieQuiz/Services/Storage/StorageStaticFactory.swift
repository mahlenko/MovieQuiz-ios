//
//  StorageStaticFactory.swift
//  MovieQuiz
//
//  Created by Sergey on 29.08.2022.
//

import Foundation

class StorageStaticFacrory: StorageFactoryProtocol {
    // MARK: - Params

    private var data: [QuizModel] = []

    // MARK: - Public methods

    func all() -> [QuizModel] {
        return data
    }

    func store(quiz: QuizModel) {
        quiz.complete(date: Date())
        data.append(quiz)
    }

    func bestQuiz() -> QuizModel? {
        guard var bestScore = data.first else { return nil }

        for score in data where score.answered.successful.count > bestScore.answered.successful.count {
            bestScore = score
        }

        return bestScore
    }
}
