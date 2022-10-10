//
//  MoviesDataResponse.swift
//  MovieQuiz
//
//  Created by Sergey on 08.09.2022.
//

import Foundation

struct MoviesDataResponse: Codable {
    let items: [MovieModel]
    let errorMessage: String
}
