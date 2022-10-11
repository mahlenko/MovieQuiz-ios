//
//  Float+Extension.swift
//  MovieQuiz
//
//  Created by Sergey on 09.09.2022.
//

import Foundation

extension Float {
    public func rounded(length: Int) -> Float {
        return Float(String(format: "%.\(length)f", self)) ?? 0.00
    }
}
