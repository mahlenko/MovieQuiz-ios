//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Sergey on 08.09.2022.
//

import Foundation

protocol QuestionDelegate: AnyObject {
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didViewQuestion(question: QuestionViewModel)
    func didFailToLoadQuestion(with error: Error)
}
