//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey on 28.08.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate { get }
    func requestNextQuestion() -> QuizQuestion?
}
