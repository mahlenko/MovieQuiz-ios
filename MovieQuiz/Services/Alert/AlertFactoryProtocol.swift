//
//  AlertFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey on 30.08.2022.
//

import Foundation
import UIKit

protocol AlertFactoryProtocol {
    func show(delegate: UIViewController, _ alert: AlertViewFactoryProtocol)
}
