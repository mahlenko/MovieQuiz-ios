//
//  StoreFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey on 29.08.2022.
//

protocol StatisticServiceProtocol {
    func all() -> [StatisticQuizViewModel]
    func store(statistic: StatisticQuizViewModel)
    func bestQuiz() -> StatisticQuizViewModel?
    func average() -> Float
    func destroy()
}
