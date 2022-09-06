//
//  StatisticDefaultService.swift
//  MovieQuiz
//
//  Created by Sergey on 06.09.2022.
//
//  Хранение истории игр в UserDefault
//

import Foundation

final class StatisticDefaultService: StatisticServiceProtocol {
    // MARK: - Properties

    let key = "statistics"

    // MARK: - Public methods

    func all() -> [StatisticViewModel] {
        var results: [StatisticViewModel] = []

        do {
            try self.getUserData().forEach { statistic in
                guard let statistic = statistic.data(using: .utf8) else {
                    return
                }

                results.append(try JSONDecoder().decode(StatisticViewModel.self, from: statistic))
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }

        return results
    }

    func store(statistic: StatisticViewModel) {
        var storage = getUserData()

        do {
            let json = try JSONEncoder().encode(statistic)
            guard let jsonString = String(data: json, encoding: .utf8) else { return }

            storage.append(jsonString)

            UserDefaults.standard.set(storage, forKey: self.key)
        } catch {
            print("Не удалось сохранить игру. Ошибка: " + error.localizedDescription)
        }
    }

    func bestQuiz() -> StatisticViewModel? {
        guard var bestScore = self.all().first else { return nil }

        for score in self.all() where score.avgAccuracy >= bestScore.avgAccuracy {
            bestScore = score
        }

        return bestScore
    }

    func destroy() {
        UserDefaults.standard.removeObject(forKey: self.key)
    }

    private func getUserData() -> [String] {
        return UserDefaults.standard.stringArray(forKey: self.key) ?? []
    }
}
