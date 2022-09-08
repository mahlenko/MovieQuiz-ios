//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey on 28.08.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    init (delegate: QuestionFactoryDelegate)
    func requestNextQuestion() -> QuizQuestion?
}
