import UIKit

/**
    View controller Movie Quiz App
*/
class MovieQuizViewController: UIViewController, QuestionDelegate {
    // MARK: - Properties

    private var alertPresenter: AlertPresenter?

    private var statisticStore: StatisticServiceProtocol?

    private let presenter = MovieQuizPresenter()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Outlets

    @IBOutlet internal var viewContainer: UIView!
    @IBOutlet internal weak var quizStepsLabel: UILabelTheme!
    @IBOutlet internal weak var quizImageView: UIImageView!
    @IBOutlet internal weak var quizQuestionLabel: UILabel!
    @IBOutlet internal weak var falseButton: UIButtonTheme!
    @IBOutlet internal weak var trueButton: UIButtonTheme!
    @IBOutlet internal weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Actions

    @IBAction private func falseButtonClicked(_ sender: Any) {
        presenter.checkAnswer(answer: false)
    }

    @IBAction private func trueButtonClicked(_ sender: Any) {
        presenter.checkAnswer(answer: true)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()

        alertPresenter = AlertPresenter(delegate: self)
        statisticStore = StatisticDefaultService()

        presenter.viewController = self
        presenter.loadMovies()
    }

    /// Загрузка вопросов прошла
    func didLoadDataFromServer() {
        presenter.loadingState(false)
        print("Фильмы успешно загружены.")
    }

    /// Ошибка при загрузки вопросов с сервера
    func didFailToLoadData(with error: Error) {
        print("Произошла ошибка загрузки фильмов: \(error.localizedDescription).")

        guard let alertPresenter = alertPresenter else {
            print(error.localizedDescription)
            return
        }

        alertPresenter.view(
            title: "😔",
            message: "\(error.localizedDescription)",
            actions: [
                UIAlertAction(title: "Попробовать еще раз", style: .default) {_ in
                    self.presenter.loadMovies()
                }
            ])
    }

    /// Ошибка при загрузки вопроса (например, неудачная загрузка фото)
    func didFailToLoadQuestion(with error: Error) {
        print("Произошла ошибка загрузки вопроса: \(error.localizedDescription)")

        guard let alertPresenter = self.alertPresenter else {
            return
        }

        alertPresenter.view(
            title: "😔",
            message: "\(error.localizedDescription)",
            actions: [
                UIAlertAction(title: "Попробовать еще раз", style: .default) {_ in
                    // попробовать показать вопрос еще раз
                    self.presenter.show()
                }
            ])
    }

    /// Показываем вопрос
    func didViewQuestion(question: QuestionViewModel) {
        quizImageView.image = question.image
        quizQuestionLabel.text = question.question
        quizStepsLabel.text = question.stepsTextLabel

        print("Вопрос показан на экран пользователя.")
    }

    /// Показываем сообщение со статистикой по завершению квиза
    func didCompleteQuiz(currenctQuizStatistic: StatisticQuizViewModel) {
        guard let statisticStore = statisticStore else { return }

        // сохраним квиз в общую статистику
        statisticStore.store(statistic: currenctQuizStatistic)

        var bestQuizScore = "---"
        let totalQuizes = statisticStore.all().count
        if let bestQuiz = statisticStore.bestQuiz() {
            bestQuizScore = "\(bestQuiz.current) (\(bestQuiz.completedAt.dateTimeString))"
        }

        let isWinner = currenctQuizStatistic.avgAccuracy == 100

        alertPresenter?.view(
            title: isWinner ? "🎉 Победа!" : "Этот раунд окончен",
            message:
                "Ваш результат: \(currenctQuizStatistic.current)\n" +
                "Количество сыграных квизов: \(totalQuizes)\n" +
                "Рекорд: \(bestQuizScore)\n" +
                "Средняя точность: \(statisticStore.average().rounded(length: 2))%",
            actions: [
                UIAlertAction(title: isWinner ? "Сыграть еще раз" : "Попробовать еще раз", style: .default) {_ in
                    self.presenter.restartQuiz()
                }
            ]
        )
    }

    // MARK: - Helpers

    private func configuration() {
        viewContainer.backgroundColor = UIColor.background

        quizImageView.layer.cornerRadius = 20
        quizImageView.image = UIImage(named: "Background")
        quizImageView.backgroundColor = UIColor.backgroundImage

        quizQuestionLabel.text = ""
        quizQuestionLabel.font = UIFont(
            name: ThemeFonts.family.bold,
            size: ThemeFonts.size.large)

        activityIndicator.color = UIColor.accent
        activityIndicator.backgroundColor = UIColor.background
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.isHidden = true

        print("✅ Configured storyboard")
    }
}
