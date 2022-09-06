//
//  ScoreAlertPresenter.swift
//  MovieQuiz
//
//  Created by Sergey on 30.08.2022.
//

import Foundation
import UIKit

class ScoreAlertViewModel: AlertViewFactoryProtocol {
    // MARK: - Alert protocol properties

    public var title: String {
        guard let statistic = storage.all().last else { return "😔 Произошла ошибка" }
        return statistic.avgAccuracy == 100.0 ? "🎉 Победа!" : "Этот раунд окончен"
    }

    public var message: String {
        return
            "Ваш результат: \(storage.all().last?.current ?? "")\n" +
            "Количество сыграных квизов: \(storage.all().count)\n" +
            "Рекорд: \(bestScoreText())\n" +
            "Средняя точность: \(accuracy())%"
    }

    public var actions: [UIAlertAction] {
        return [ restartAction() ]
    }

    // MARK: - Private properties

    private let storage: StatisticServiceProtocol

    /// Обратный вызов по единственной кнопке алерта
    private var callback: (() -> Void)

    init(storage: StatisticServiceProtocol, callback: @escaping () -> Void) {
        self.storage = storage
        self.callback = callback
    }

    // MARK: - Private methods

    private func restartAction() -> UIAlertAction {
        return UIAlertAction(
            title: "Попробовать еще раз",
            style: .default
        ) {_ in
            self.callback()
        }
    }

    /// Результат лучшего сыгранного квиза
    private func bestScoreText() -> String {
        guard let bestQuiz = storage.bestQuiz() else { return "" }
        return "\(bestQuiz.current) (\(bestQuiz.completedAt.dateTimeString))"
    }

    /// Средний результат сыгранных квизов
    private func accuracy() -> Float {
        var accuracies: [Float] = []

        for quiz in storage.all() {
            accuracies.append(quiz.avgAccuracy)
        }

        return Float(accuracies.reduce(0, +) / Float(accuracies.count))
    }
}
