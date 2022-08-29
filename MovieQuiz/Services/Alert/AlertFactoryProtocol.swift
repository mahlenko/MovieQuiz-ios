//
//  AlertFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey on 30.08.2022.
//

import Foundation
import UIKit

protocol AlertFactoryProtocol {
    var title: String { get }
    var message: String { get }
    var actions: [UIAlertAction] { get }
}
