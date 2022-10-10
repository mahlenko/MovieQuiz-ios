//
//  QuestionNetworkFactory.swift
//  MovieQuiz
//
//  Created by Sergey on 07.09.2022.
//

import Foundation
import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    // MARK: - Properties

    private var items: [MovieModel]?
    private let networkClient: NetworkRouting
    private let apiKey = "k_5cudelqo"

    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/\(apiKey)") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }

        return url
    }

    init(client: NetworkRouting = NetworkClient()) {
        self.networkClient = client
    }

    // MARK: - Public methods

    func requestNextQuestion() -> QuestionModel? {
        guard let movie = items?.randomElement() else { return nil }

        if movie.imDbRating.isEmpty {
            return requestNextQuestion()
        }

        return Converter().toQuestion(movie: movie)
    }

    func load(handler: @escaping (Result<[MovieModel], Error>) -> Void) {
        networkClient.get(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    // Декодируем JSON
                    let responseData = try JSONDecoder().decode(
                        MoviesDataResponse.self,
                        from: data
                    )

                    // Вернем ошибку IMDB API
                    guard responseData.errorMessage.isEmpty else {
                        let error = responseData.errorMessage
                        throw IMDBError.invalidRequstException(error)
                    }

                    self.items = responseData.items

                    handler(.success(responseData.items))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
