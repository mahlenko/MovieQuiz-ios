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

    private var network: NetworkRouting = NetworkClient()
    private var questionFactory: QuestionFactoryProtocol
    private var questionCurrent: QuestionModel?
    private var storage: StatisticServiceProtocol = StatisticDefaultService()
    private var statisticQuiz = StatisticQuizModel()

    private let totalQuestionsQuiz = 10

    weak var viewController: MovieQuizViewController?

    // MARK: - Lifecicle

    init() {
        questionFactory = QuestionFactory(client: self.network)
    }

    // MARK: - Logic methods

    func loadMovies() {
        loadingState(true)

        guard let questionFactory = questionFactory as? QuestionFactory else { return }

        questionFactory.load { result in
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
        loadingState(true)
        setImageBorderView()

        guard let questionCurrent = questionCurrent else { return }

        // Загрузим изображение для вопроса
        Download(network: network).image(url: questionCurrent.image) { result in
            DispatchQueue.main.async {
                self.loadingState(false)

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

    func checkAnswer(answer: Bool) {
        buttonsEnabled(false)

        let result = questionCurrent?.correctAnswer == answer

        // покажем результат ответа цветом постера
        if result {
            resultSuccessView()
        } else {
            resultFailureView()
        }

        guard let questionCurrent = questionCurrent else { return }

        statisticQuiz.store(question: questionCurrent, result: result)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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

    /// Показать/спрятать лоадер
    func loadingState(_ show: Bool) {
        buttonsEnabled(!show)

        viewController?.activityIndicator.isHidden = !show
        viewController?.activityIndicator.startAnimating()
    }

    private func buttonsEnabled(_ enabled: Bool) {
        let buttons = [
            viewController?.trueButton,
            viewController?.falseButton
        ]

        buttons.forEach { $0?.isEnabled = enabled }
    }

    private func resultSuccessView() {
        setImageBorderView(UIColor.success)
        print("🎉 The answer is correct")
    }

    private func resultFailureView() {
        setImageBorderView(UIColor.fail)
        print("😔 The answer is NOT correct")
    }

    private func setImageBorderView(_ color: UIColor? = .none) {
        viewController?.quizImageView.layer.borderColor = color?.cgColor
        viewController?.quizImageView.layer.borderWidth = color == .none ? .nan : 8.0
    }
}
