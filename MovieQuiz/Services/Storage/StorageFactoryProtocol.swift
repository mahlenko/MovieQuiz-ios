//
//  StoreFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey on 29.08.2022.
//

import Foundation

protocol StorageFactoryProtocol {
    func all() -> [QuizModel]
    func store(quiz: QuizModel)
    func bestQuiz() -> QuizModel?
}
