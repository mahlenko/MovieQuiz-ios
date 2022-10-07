//
//  QuestionNetworkFactory.swift
//  MovieQuiz
//
//  Created by Sergey on 07.09.2022.
//

import Foundation
import UIKit

final class QuestionNetworkFactory: QuestionFactoryProtocol {
    // MARK: - Properties

    private let client: NetworkRouting
    private let apiKey: String

    public var data: [QuizQuestion] = []

    init(client: NetworkRouting, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    // MARK: - Private methods
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/\(apiKey)") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }

        return url
    }

    // MARK: - Public methods

    func requestNextQuestion() -> QuizQuestion? {
        let index = (0..<data.count).randomElement() ?? 0
        return self.data[safe: index]
    }

    func load(handler: @escaping (Result<[QuizQuestion], Error>) -> Void) {
        client.get(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(MoviesDataResponse.self, from: data)

                    // Создаем исключение с ошибкой из IMDB API
                    guard json.errorMessage.isEmpty else {
                        throw IMDBError.invalidRequstException(json.errorMessage)
                    }

                    // Фильтруем список фильмов, оставляем фильмы с рейтингом.
                    // (не все фильмы с заполненым с рейтингом)
                    let responseData = json.items.filter { item in
                        return !item.imDbRating.isEmpty
                    }

                    // Собираем список вопросов
                    responseData.forEach { movie in
                        guard let rating = Float(movie.imDbRating) else {
                            return
                        }

                        //
                        self.data.append(
                            QuizQuestion(
                                image: movie.image,
                                rating: rating,
                                text: "Рейтинг \"\(movie.title)\" больше, чем 7?",
                                correctAnswer: rating > 7.0)
                        )
                    }

                    DispatchQueue.main.async {
                        handler(.success(self.data))
                    }
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
