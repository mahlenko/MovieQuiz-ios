//
//  StorageStaticFactory.swift
//  MovieQuiz
//
//  Created by Sergey on 29.08.2022.
//

import Foundation

final class StatisticMockService: StatisticServiceProtocol {
    // MARK: - Params

    private var data: [StatisticViewModel] = []

    // MARK: - Public methods

    func all() -> [StatisticViewModel] {
        return data
    }

    func store(statistic: StatisticViewModel) {
        data.append(statistic)
    }

    func destroy() {
        self.data = []
    }

    func bestQuiz() -> StatisticViewModel? {
        guard var bestScore = all().first else { return nil }

        for score in all() where score.avgAccuracy >= bestScore.avgAccuracy {
            bestScore = score
        }

        return bestScore
    }
}
