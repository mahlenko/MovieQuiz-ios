//
//  States+Controls+Extension.swift
//  MovieQuiz
//
//  Created by Sergey on 29.08.2022.
//

import Foundation
import UIKit

extension MovieQuizViewController {
    internal func successImageView() {
        setImageBorderView(UIColor.success)
        print("🎉 The answer is correct")
    }

    internal func failedImageView() {
        setImageBorderView(UIColor.fail)
        print("😔 The answer is NOT correct")
    }

    internal func setImageBorderView(_ color: UIColor? = .none) {
        quizImageView.layer.borderColor = color?.cgColor
        quizImageView.layer.borderWidth = color == .none ? .nan : 8.0
    }

    internal func enableControls(_ enable: Bool) {
        trueButton.isEnabled = enable
        falseButton.isEnabled = enable
    }

    internal func configuration() {
        viewContainer.backgroundColor = UIColor.background
        quizImageView.layer.cornerRadius = 20
        quizQuestionLabel.font = UIFont(name: ThemeFonts.family.bold, size: ThemeFonts.size.large)
        print("✅ Configured storyboard")
    }
}
