//
//  MovieDataConvert.swift
//  MovieQuiz
//
//  Created by Sergey on 08.10.2022.
//

import Foundation

class MovieToQuizQuestionConverter {
    ///
    func handle(response: MoviesDataResponse) -> [QuizQuestion] {
        var data: [QuizQuestion] = []

        // Собираем список вопросов
        response.items.forEach { movie in
            // Не у всех фильмов присутствует рейтинг
            guard let rating = Float(movie.imDbRating) else { return }

            //
            data.append(
                QuizQuestion(
                    image: movie.image,
                    rating: rating,
                    text: "Рейтинг \"\(movie.title)\" больше, чем 7?",
                    correctAnswer: rating > 7.0)
            )
        }

        return data
    }
}
