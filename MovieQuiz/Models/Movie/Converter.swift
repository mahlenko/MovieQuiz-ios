//
//  MovieDataConvert.swift
//  MovieQuiz
//
//  Created by Sergey on 08.10.2022.
//

import Foundation

class Converter {
    func toQuestion(movie: MovieModel) -> QuestionModel {
        let rating = Float(movie.imDbRating) ?? Float(0.0)

        return QuestionModel(
            image: movie.image,
            rating: rating,
            text: "Рейтинг \"\(movie.title)\" больше, чем 7?",
            correctAnswer: rating > 7.0)
    }
}
