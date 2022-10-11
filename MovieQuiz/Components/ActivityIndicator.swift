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
        self.activityIndicatorView = activityIndicatorView
    }

    func show() {
        activityIndicatorView?.isHidden = false
        activityIndicatorView?.startAnimating()
    }

    func hide() {
        activityIndicatorView?.isHidden = true
        activityIndicatorView?.stopAnimating()
    }
}
