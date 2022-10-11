//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Sergey on 09.10.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    // MARK: - Properties

    private var network: NetworkRouting
    private var questionFactory: QuestionFactoryProtocol
    private var questionCurrent: QuestionModel?
    private var storage: StatisticServiceProtocol = StatisticDefaultService()
    private var statisticQuiz = StatisticQuizModel()

    private let totalQuestionsQuiz = 10

    weak var viewController: MovieQuizViewController?

    // MARK: - Lifecicle

    init(network: NetworkRouting) {
        self.network = network
        questionFactory = QuestionFactory(client: self.network)
    }

    // MARK: - Logic methods

    func loadMovies() {
        guard let questionFactory = questionFactory as? QuestionFactory else { return }

        questionFactory.load { [weak self] result in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.setNextQuestion()
                    self.show()
                case .failure(let error):
                    self.viewController?.didFailToLoadData(with: error)
                }
            }
        }
    }

    func setNextQuestion() {
        questionCurrent = self.questionFactory.requestNextQuestion()
    }

    /// Покажем текущий вопрос
    func show() {
        guard let questionCurrent = questionCurrent else { return }

        // Загрузим изображение для вопроса
        Download(network: network).image(url: questionCurrent.image) { [weak self] result in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async {
                let questionImage: UIImage

                switch result {
                case .success(let image):
                    questionImage = image
                case .failure(let error):
                    // покажем изображение по-умолчанию
                    print(error.localizedDescription)

                    guard let imagePlaceholder = UIImage(named: "Error") else {
                        return
                    }

                    questionImage = imagePlaceholder
                }

                // Показываем вопрос на экран
                self.viewController?.didViewQuestion(question: QuestionViewModel(
                    image: questionImage,
                    question: questionCurrent.text,
                    stepsTextLabel: self.statisticQuiz.positionText(total: self.totalQuestionsQuiz) ))
            }
        }
    }

    func checkAnswer(answer: Bool, handle: (Bool) -> Void) {
        let result = questionCurrent?.correctAnswer == answer
        handle(result)

        guard let questionCurrent = questionCurrent else { return }

        statisticQuiz.store(question: questionCurrent, result: result)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else {
                return
            }

            if self.statisticQuiz.position() >= self.totalQuestionsQuiz {
                self.completeQuiz()
            } else {
                self.setNextQuestion()
                self.show()
            }
        }
    }

    /// Показать статистику и завершим квиз
    func completeQuiz() {
        let statistic = StatisticQuizViewModel(
            current: statisticQuiz.resultText(),
            avgAccuracy: statisticQuiz.average(),
            completedAt: Date())

        self.viewController?.didCompleteQuiz(currenctQuizStatistic: statistic)
    }

    func restartQuiz() {
        statisticQuiz.reset()

        setNextQuestion()
        show()
    }
}
