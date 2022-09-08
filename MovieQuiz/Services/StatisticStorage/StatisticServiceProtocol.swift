//
//  StoreFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Sergey on 29.08.2022.
//

protocol StatisticServiceProtocol {
    func all() -> [StatisticViewModel]
    func store(statistic: StatisticViewModel)
    func bestQuiz() -> StatisticViewModel?
    func average() -> Float
    func destroy()
}
