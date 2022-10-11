//
//  ActivityIndicator.swift
//  MovieQuiz
//
//  Created by Sergey on 11.10.2022.
//

import Foundation
import UIKit

struct ActivityIndicator: ActivityIndicatorProtocol {
    private var activityIndicatorView: UIActivityIndicatorView?

    init (activityIndicatorView: UIActivityIndicatorView) {
        activityIndicatorView.hidesWhenStopped = true
        self.activityIndicatorView = activityIndicatorView
    }

    func show() {
        activityIndicatorView?.startAnimating()
    }

    func hide() {
        activityIndicatorView?.stopAnimating()
    }
}
