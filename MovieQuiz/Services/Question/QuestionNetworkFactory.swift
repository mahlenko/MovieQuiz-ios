//
//  QuestionIMDBFactory.swift
//  MovieQuiz
//
//  Created by Sergey on 07.09.2022.
//

import Foundation
import UIKit

final class QuestionNetworkFactory: QuestionFactoryProtocol {
    // MARK: - Properties

    public var delegate: QuestionFactoryDelegate
    private let client: NetworkClient
    private let apiKey = "k_5cudelqo"

    public var data: [QuizQuestion] = []

    init(client: NetworkClient, delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
        self.client = client
    }

    // MARK: - Public methods

    func requestNextQuestion() -> QuizQuestion? {
        let index = (0..<data.count).randomElement() ?? 0
        return self.data[safe: index]
    }

    public func load() {
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/\(apiKey)") else { return }

        self.client.get(url: url) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.delegate.didFailToLoadData(with: error)
                case .success(let data):
                    do {
                        let json = try JSONDecoder().decode(MoviesDataResponse.self, from: data)

                        // TODO: Ошибка может быть не по поводу ключа, не знаю как генерить Error с сообщением
                        guard json.errorMessage.isEmpty else {
                            self.delegate.didFailToLoadData(with: ImdbError.invalidKey)
                            return
                        }

                        //
                        let responseData = json.items.filter { item in
                            return !item.imDbRating.isEmpty
                        }

                        responseData.forEach { movie in
                            let rating = Float(movie.imDbRating) ?? 0.0

                            self.data.append(
                                QuizQuestion(
                                    image: movie.image,
                                    rating: rating,
                                    text: "Рейтинг \"\(movie.title)\" больше, чем 7?",
                                    correctAnswer: rating > 7.0)
                            )
                        }
                    } catch {
                        self.delegate.didFailToLoadData(with: error)
                    }

                    self.delegate.didLoadDataFromServer()
                }
            }
        }
    }
}
