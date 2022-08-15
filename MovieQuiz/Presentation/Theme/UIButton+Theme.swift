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
        tintColor = UIColor.appBackground
        backgroundColor = UIColor.appDefault

        titleLabel?.font = UIFont(
            name: StyleDefault.fontBold,
            size: StyleDefault.fontSize)

        self.titleEdgeInsets = UIEdgeInsets(
            top: 18.0,
            left: 16.0,
            bottom: 18.0,
            right: 16.0)
    }
}
