//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey on 28.08.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
