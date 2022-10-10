//
//  StorageStaticFactory.swift
//  MovieQuiz
//
//  Created by Sergey on 29.08.2022.
//

import Foundation

final class StatisticMockService: StatisticServiceProtocol {
    // MARK: - Params

    private var data: [StatisticQuizViewModel] = []

    // MARK: - Public methods

    func all() -> [StatisticQuizViewModel] {
        return data
    }

    func store(statistic: StatisticQuizViewModel) {
        data.append(statistic)
    }

    func average() -> Float {
        var accuracies: [Float] = []

        for statistic in all() {
            accuracies.append(statistic.avgAccuracy)
        }

        return Float(accuracies.reduce(0, +) / Float(accuracies.count))
    }

    func destroy() {
        self.data = []
    }

    func bestQuiz() -> StatisticQuizViewModel? {
        guard var bestScore = all().first else { return nil }

        for score in all() where score.avgAccuracy >= bestScore.avgAccuracy {
            bestScore = score
        }

        return bestScore
    }
}
