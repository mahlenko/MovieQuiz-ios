//
//  QuestionIMDBFactory.swift
//  MovieQuiz
//
//  Created by Sergey on 07.09.2022.
//

import Foundation
import UIKit

final class QuestionIMDBFactory: QuestionFactoryProtocol {
    // MARK: - Properties

    public let delegate: QuestionFactoryDelegate

    private let apiKey = "k_5cudelqo"

    private var index: Int?

    var data: [QuizQuestion] = []

    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
        loadMovies()
    }

    // MARK: - Public methods

    func requestNextQuestion() -> QuizQuestion? {
        var currentIndex = index ?? -1
        currentIndex += 1

        index = currentIndex

        return self.data[safe: currentIndex]
    }

    func loadMovies() {
        NetworkImDBClient(apiKey: apiKey)
            .get(method: MostPopularMovies()) { [weak self] result in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        self.delegate.didFailToLoadData(with: error)
                    case .success(let data):
                        do {
                            let json = try JSONDecoder().decode(MoviesDataResponse.self, from: data)

                            // TODO: Ошибка может быть не по поводу ключа, не знаю как генерить Error с сообщением
                            if !json.errorMessage.isEmpty {
                                self.delegate.didFailToLoadData(with: ImdbError.invalidKey)
                                return
                            }

                            let responseData = json.items.filter({ item in
                                return !item.imDbRating.isEmpty
                            })
                                .shuffled()
                                .chunked(into: 10)
                                .first

                            responseData?.forEach({ movieData in
                                let rating = Float(movieData.imDbRating) ?? 0.0

                                self.data.append(
                                    QuizQuestion(
                                        image: movieData.image,
                                        rating: rating,
                                        text: "Рейтинг \"\(movieData.title)\" больше, чем 7?",
                                        correctAnswer: rating > 7.0
                                    )
                                )
                            })
                        } catch {
                            self.delegate.didFailToLoadData(with: error)
                        }

                        self.delegate.didLoadDataFromServer()
                    }
                }
            }
    }
}
