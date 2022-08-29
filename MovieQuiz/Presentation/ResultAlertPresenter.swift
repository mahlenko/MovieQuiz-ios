//
//  ViewScore.swift
//  MovieQuiz
//
//  Created by Sergey on 15.08.2022.
//

import Foundation
import UIKit

/**
    Helper class by score message
*/
class ResultAlertPresenter {
    // MARK: - Properties

    let storage: StorageFactoryProtocol
    let delegate: UIViewController

    init(storage: StorageFactoryProtocol, delegate: UIViewController) {
        self.storage = storage
        self.delegate = delegate
    }

    // MARK: - Public methods

    func show(closure: @escaping () -> Void) {
        let scoreModel = QuizScoreViewModel(
            title: title(),
            message: message(),
            buttonText: "Попробовать еще раз")

        let alert = UIAlertController(
            title: scoreModel.title,
            message: scoreModel.message,
            preferredStyle: .alert)

        alert.addAction(
            UIAlertAction(
                title: scoreModel.buttonText,
                style: .default
            ) {_ in
                closure()
            }
        )

        delegate.present(alert, animated: true) {
            // поиск слоя с фоном алерта
            guard
                let window = UIApplication.shared.windows.first,
                let overlay = window.subviews.last?.layer.sublayers?.first
            else { return }

            // замена цвета фона
            self.animateOverlayColorAlert(overlay, color: ThemeAlert.overlayColor)
        }
    }

    // MARK: - Private methods

    private func title() -> String {
        guard let quiz = storage.all().last else { return "😔 Произошла ошибка" }
        return quiz.isWin() ? "🎉 Победа!" : "Этот раунд окончен"
    }

    private func message() -> String {
        return
            "Ваш результат: \(storage.all().last?.resultText() ?? "")\n" +
            "Количество сыграных квизов: \(storage.all().count)\n" +
            "Рекорд: \(bestScoreText())\n" +
            "Средняя точность: \(accuracy())"
    }

    private func bestScoreText() -> String {
        guard
            let bestQuiz = storage.bestQuiz(),
            let completedAt = bestQuiz.completedAt
        else { return "" }

        return "\(bestQuiz.resultText()) (\(completedAt.dateTimeString))"
    }

    private func accuracy() -> Float {
        var accuracies: [Float] = []

        for quiz in storage.all() { accuracies.append(quiz.percentAccuracy()) }

        return Float(accuracies.reduce(0, +) / Float(accuracies.count))
    }

    // MARK: - Helpers

    private func animateOverlayColorAlert(
        _ overlay: CALayer,
        color: UIColor,
        alpha: CGFloat = 0.6
    ) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.speed = 0.15

        overlay.add(animation, forKey: nil)

        DispatchQueue.main.async {
            overlay.backgroundColor = color.withAlphaComponent(alpha).cgColor
        }
    }
}
