import UIKit

/**
    View controller Movie Quiz App
*/
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Properties

    private var movies: QuestionFactoryProtocol?

    private var storage: StatisticServiceProtocol = StatisticDefaultService()

    private var alertPresenter: ResultAlertPresenter?

    private var quiz: QuizModel?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Outlets

    @IBOutlet private var viewContainer: UIView!
    @IBOutlet private weak var quizStepsLabel: UILabelTheme!
    @IBOutlet private weak var quizImageView: UIImageView!
    @IBOutlet private weak var quizQuestionLabel: UILabel!
    @IBOutlet private weak var falseButton: UIButtonTheme!
    @IBOutlet private weak var trueButton: UIButtonTheme!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Actions

    @IBAction private func falseButtonClicked(_ sender: Any) {
        check(answer: false)
    }

    @IBAction private func trueButtonClicked(_ sender: Any) {
        check(answer: true)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = ResultAlertPresenter(delegate: self)
        configuration()

        create()
    }

    func didLoadDataFromServer() {
        activityIndicatorShowing(show: false)

        guard let movies = movies else { return }

        quiz = QuizModel(questions: movies)
        next()
    }

    func didFailToLoadData(with error: Error) {
        activityIndicatorShowing(show: false)

        guard let alertPresenter = alertPresenter else {
            print(error)
            print(error.localizedDescription)
            return
        }

        alertPresenter.view(
            title: "😔",
            message: "\(error): \(error.localizedDescription)",
            actions: [
                UIAlertAction(title: "Попробовать еще раз", style: .default) {_ in
                    self.create()
                }
            ])
    }

    func didReceiveNextQuestion(question: QuizStepViewModel?) {
        guard let question = question else { return }

        quizImageView.image = question.image
        quizQuestionLabel.text = question.question
        quizStepsLabel.text = question.stepsTextLabel

        enableControls(true)
    }

    // MARK: - Private methods

    /// Создать игру/рестарт игры
    private func create() {
        activityIndicatorShowing(show: true)
        movies = QuestionIMDBFactory(delegate: self)
    }

    /// Проверка ответа пользователя
    private func check(answer: Bool) {
        guard let quiz = quiz else { return }

        enableControls(false)

        if let isCorrectResult = quiz.checkAnswer(answer: answer) {
            isCorrectResult ? successImageView() : failedImageView()
        }

        // Go to the next question or wait for results with a delay of 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setImageBorderView()

            quiz.isComplete()
                ? self.complete(quiz: quiz)
                : self.next()
        }
    }

    /// Показать следующий вопрос
    private func next() {
        guard let quiz = quiz else { return }
        quiz.nextQuestion()
    }

    /// Показать статистику
    private func complete(quiz: QuizModel) {
        let statistic = StatisticViewModel(
            current: quiz.resultText(),
            avgAccuracy: quiz.percentAccuracy(),
            completedAt: Date()
        )

        storage.store(statistic: statistic)

        // показать алерт с информацией о результатах

        guard let alertPresenter = alertPresenter else { return }
        guard let bestScrore = storage.bestQuiz() else { return }

        let bestScore = "\(bestScrore.current) (\(bestScrore.completedAt.dateTimeString)"

        alertPresenter.view(
            title: statistic.avgAccuracy == 100 ? "🎉 Победа!" : "Этот раунд окончен",
            message:
                "Ваш результат: \(statistic.current)\n" +
                "Количество сыграных квизов: \(storage.all().count)\n" +
                "Рекорд: \(bestScore)\n" +
                "Средняя точность: \(storage.average().rounded(length: 2))%",
            actions: [
                UIAlertAction(title: "Попробовать еще раз", style: .default) {_ in
                    self.create()
                }
            ]
        )
    }

    // MARK: - Helpers

    /// Показать/спрятать лоадер
    private func activityIndicatorShowing(show: Bool) {
        activityIndicator.isHidden = !show
        show
            ? activityIndicator.startAnimating()
            : activityIndicator.stopAnimating()
    }

    private func successImageView() {
        setImageBorderView(UIColor.success)
        print("🎉 The answer is correct")
    }

    private func failedImageView() {
        setImageBorderView(UIColor.fail)
        print("😔 The answer is NOT correct")
    }

    private func setImageBorderView(_ color: UIColor? = .none) {
        quizImageView.layer.borderColor = color?.cgColor
        quizImageView.layer.borderWidth = color == .none ? .nan : 8.0
    }

    private func enableControls(_ enable: Bool) {
        [trueButton, falseButton].forEach { $0?.isEnabled = enable }
    }

    private func configuration() {
        viewContainer.backgroundColor = UIColor.background
        quizImageView.layer.cornerRadius = 20
        quizImageView.image = UIImage(named: "Background")
        quizQuestionLabel.font = UIFont(name: ThemeFonts.family.bold, size: ThemeFonts.size.large)
        quizQuestionLabel.text = ""

        activityIndicator.color = UIColor.accent
        activityIndicator.backgroundColor = UIColor.background
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.isHidden = true

        enableControls(false)

        print("✅ Configured storyboard")
    }
}
