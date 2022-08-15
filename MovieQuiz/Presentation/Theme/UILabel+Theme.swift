//
//  UILabel+Theme.swift
//  MovieQuiz
//
//  Created by Sergey on 15.08.2022.
//

import Foundation
import UIKit

class UILabelTheme: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        font = UIFont(
            name: StyleDefault.fontMedium,
            size: StyleDefault.fontSize)
    }
}
