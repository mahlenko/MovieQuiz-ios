//
//  UIButton+Theme.swift
//  MovieQuiz
//
//  Created by Sergey on 15.08.2022.
//

import Foundation
import UIKit

class UIButtonTheme: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layer.cornerRadius = 15
        backgroundColor = UIColor.accent
        tintColor = UIColor.background

        titleLabel?.font = UIFont(
            name: ThemeFonts.family.bold,
            size: ThemeFonts.size.default)

        self.titleEdgeInsets = UIEdgeInsets(
            top: 18.0,
            left: 16.0,
            bottom: 18.0,
            right: 16.0)
    }
}
