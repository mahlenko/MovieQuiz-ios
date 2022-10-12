//
//  StatisticViewModel.swift
//  MovieQuiz
//
//  Created by Sergey on 06.09.2022.
//

import Foundation

struct StatisticQuizViewModel: Codable {
    let current: String
    let avgAccuracy: Float
    let completedAt: Date
}
