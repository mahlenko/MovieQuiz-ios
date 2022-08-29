//
//  ScoreAlertPresenter.swift
//  MovieQuiz
//
//  Created by Sergey on 30.08.2022.
//

import Foundation
import UIKit

class ScoreAlertViewModel: AlertFactoryProtocol {
    // MARK: - Alert protocol properties

    public var title: String {
        guard let quiz = storage.all().last else { return "😔 Произошла ошибка" }
        return quiz.isWin() ? "🎉 Победа!" : "Этот раунд окончен"
    }

    public var message: String {
        return
            "Ваш результат: \(storage.all().last?.resultText() ?? "")\n" +
            "Количество сыграных квизов: \(storage.all().count)\n" +
            "Рекорд: \(bestScoreText())\n" +
            "Средняя точность: \(accuracy())%"
    }

    public var actions: [UIAlertAction] {
        return [ restartAction() ]
    }

    // MARK: - Private properties

    private let storage: StorageFactoryProtocol

    /// Обратный вызов по единственной кнопке алерта
    private var callback: (() -> Void)

    init(storage: StorageFactoryProtocol, callback: @escaping () -> Void) {
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
        guard
            let bestQuiz = storage.bestQuiz(),
            let completedAt = bestQuiz.completedAt
        else { return "" }

        return "\(bestQuiz.resultText()) (\(completedAt.dateTimeString))"
    }

    /// Средний результат сыгранных квизов
    private func accuracy() -> Float {
        var accuracies: [Float] = []

        for quiz in storage.all() { accuracies.append(quiz.percentAccuracy()) }

        return Float(accuracies.reduce(0, +) / Float(accuracies.count))
    }
}
