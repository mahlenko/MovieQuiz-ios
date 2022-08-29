//
//  StoreFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey on 29.08.2022.
//

import Foundation

protocol StorageFactoryProtocol {
    func all() -> [Quiz]
    func store(quiz: Quiz)
    func bestQuiz() -> Quiz?
}
