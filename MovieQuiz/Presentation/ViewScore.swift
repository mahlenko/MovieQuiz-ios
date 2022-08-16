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
class ViewScore {
    // MARK: - Properties

    let quiz: Quiz
    let store: [Quiz]
    let delegate: UIViewController

    init(store: [Quiz], quiz: Quiz, delegate: UIViewController) {
        self.store = store
        self.quiz = quiz
        self.delegate = delegate
    }

    // MARK: - Public methods

    func alertComplete(closure: @escaping () -> Void) {
        let scoreModel = QuizScoreViewModel(
            title: quiz.answered.successful.count == quiz.countAnsweredToComplete
                ? "🎉 Победа!"
                : "Этот раунд окончен",
            message: message(),
            buttonText: "Попробовать еще раз")

        let alert = UIAlertController(
            title: scoreModel.title,
            message: scoreModel.message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: scoreModel.buttonText,
            style: .default
        ) {_ in
            closure()
        }

        alert.addAction(action)

        delegate.present(alert, animated: true) {
            // поиск слоя с фоном алерта
            guard let window = UIApplication.shared.windows.first else { return }
            guard let overlay = window.subviews.last?.layer.sublayers?.first else { return }

            // замена цвета фона
            self.animateOverlayColorAlert(overlay, color: StyleDefault.overlayColor)
        }
    }

    // MARK: - Private methods

    private func message() -> String {
        guard let lastQuiz = store.last else { return "" }
        guard let bestResult = bestResult() else { return "" }
        guard let bestDateString = bestResult.completedAt else { return "" }

        let bestScoreString = [
            "\(bestResult.answered.successful.count)/\(bestResult.countAnsweredToComplete)",
            "(\(bestDateString.dateTimeString))"
        ].joined(separator: " ")

        return [
            "Ваш результат: \(lastQuiz.answered.successful.count)/\(lastQuiz.countAnsweredToComplete)",
            "Количество сыграных квизов: \(store.count)",
            "Рекорд: \(bestScoreString)",
            "Средняя точность: \(NSString(format: "%.2f", accuracyAvg()))%"
        ].joined(separator: "\n")
    }

    /// Search the best quiz
    private func bestResult() -> Quiz? {
        guard var bestScore = store.first else { return nil }

        for score in store
            where score.answered.successful.count > bestScore.answered.successful.count {
                bestScore = score
            }

        return bestScore
    }

    /// Search for the average accuracy of quizzes
    private func accuracyAvg() -> Float {
        var accuracies: [Float] = []

        for quiz in store { accuracies.append(quiz.percentAccuracy()) }

        return accuracies.reduce(0, +) / Float(accuracies.count)
    }

    private func animateOverlayColorAlert(_ overlay: CALayer, color: UIColor, alpha: CGFloat = 0.6) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.speed = 0.15

        overlay.add(animation, forKey: nil)

        // fix: моргание 🤷‍♂️, не знаю как это должно быть по другому
        // возможно тут и правильно так, типа другой задачей, но не уверен
        DispatchQueue.main.async {
            overlay.backgroundColor = color.withAlphaComponent(alpha).cgColor
        }
    }
}
