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

    public var items: [QuizQuestion] = []

    init(apiKey: String, client: NetworkRouting = NetworkClient()) {
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
        return items.randomElement()
    }

    func load(handler: @escaping (Result<MoviesDataResponse, Error>) -> Void) {
        client.get(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(MoviesDataResponse.self, from: data)

                    // Создаем исключение с ошибкой из IMDB API
                    guard json.errorMessage.isEmpty else {
                        throw IMDBError.invalidRequstException(json.errorMessage)
                    }

                    handler(.success(json))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
