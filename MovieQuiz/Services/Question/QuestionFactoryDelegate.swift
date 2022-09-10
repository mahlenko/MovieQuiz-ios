//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Sergey on 08.09.2022.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizStepViewModel?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailToLoadQuestion(with error: Error)
}
