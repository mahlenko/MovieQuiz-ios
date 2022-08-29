//
//  ViewScore.swift
//  MovieQuiz
//
//  Created by Sergey on 15.08.2022.
//

import Foundation
import UIKit

/**
    Alert model default
*/
class AlertFactory {
    // MARK: - Properties

    /// Alert model
    private let alert: AlertFactoryProtocol

    /// View for showing alert
    private let delegate: UIViewController

    init(_ alert: AlertFactoryProtocol, delegate: UIViewController) {
        self.alert = alert
        self.delegate = delegate
    }

    // MARK: - Public methods

    public func show() {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert)

        if alert.actions.isEmpty == false {
            alert.actions.forEach { action in
                alertController.addAction(action)
            }
        }

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

    // MARK: - Private methods

    private func animateOverlayColorAlert(_ overlay: CALayer) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.speed = 0.2
        animation.fromValue = overlay.backgroundColor

        overlay.add(animation, forKey: nil)

        DispatchQueue.main.async {
            overlay.backgroundColor = UIColor.overlay.cgColor
        }
    }
}