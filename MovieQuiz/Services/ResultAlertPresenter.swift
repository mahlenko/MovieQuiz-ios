//
//  AlertViewService.swift
//  MovieQuiz
//
//  Created by Sergey on 08.09.2022.
//

import Foundation
import UIKit

class ResultAlertPresenter {
    // MARK: - Properties

    let delegate: QuestionFactoryDelegate

    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }

    // MARK: - Public methods

    public func view(title: String, message: String, actions: [UIAlertAction]?) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)

        guard let actions = actions else { return }
        actions.forEach { action in
            alertController.addAction(action)
        }

        if let delegate = self.delegate as? UIViewController {
            DispatchQueue.main.async {
                delegate.present(alertController, animated: true) {
                    // поиск слоя с фоном алерта
                    guard
                        let window = UIApplication.shared.windows.first,
                        let overlay = window.subviews.last?.layer.sublayers?.first
                    else { return }

                    // замена цвета фона
                    self.animateOverlayColorAlert(overlay)
                }
            }
        }
    }

    // MARK: - Private methods

    private func animateOverlayColorAlert(_ overlay: CALayer) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.speed = 0.2
        animation.fromValue = overlay.backgroundColor

        overlay.add(animation, forKey: nil)
        overlay.backgroundColor = UIColor.overlay.cgColor
    }
}
