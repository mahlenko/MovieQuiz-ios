import UIKit

<<<<<<< HEAD
=======
// MARK: - Structures

struct QuizQuestion {
    let image: String
    let rating: Float
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage?
    let question: String
    let stepsTextLabel: String
}

struct QuizScoreViewModel {
    let title: String
    let message: String
    let buttonText: String
}

struct QuizAnswered {
    var successful: [QuizQuestion] = []
    var failed: [QuizQuestion] = []

    // MARK: - Public methods

    func position() -> Int {
        return successful.count + failed.count
    }

    mutating func store(question: QuizQuestion, result: Bool) {
        result
            ? successful.append(question)
            : failed.append(question)
    }
}

>>>>>>> project_sprint_3_start
/**
    View controller Movie Quiz App
*/
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Properties

<<<<<<< HEAD
    private var questions: QuestionFactoryProtocol?

    private var storage: StatisticServiceProtocol = StatisticDefaultService()

    private var alertPresenter: ResultAlertPresenter?

    private var quiz: QuizModel?
=======
    private var quizes: [Quiz] = []
    private var currentQuiz: Quiz?
>>>>>>> project_sprint_3_start

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

        guard let questions = questions else { return }
        quiz = QuizModel(questions: questions)
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
            message: "\(error.localizedDescription)",
            actions: [
                UIAlertAction(title: "Попробовать еще раз", style: .default) {_ in
                    self.didLoadDataFromServer()
                }
            ])
    }

    func didFailToLoadQuestion(with error: Error) {
        activityIndicatorShowing(show: false)
        guard let alertPresenter = alertPresenter else { return }

        alertPresenter.view(
            title: "😔",
            message: "\(error.localizedDescription)",
            actions: [
                UIAlertAction(title: "Попробовать еще раз", style: .default) {_ in
                    guard let quiz = self.quiz else { return }
                    quiz.showQuestion()
                }
            ])
    }

    func didReceiveNextQuestion(question: QuizStepViewModel?) {
        guard let question = question else { return }

        self.setImageBorderView()

        quizImageView.image = question.image
        quizQuestionLabel.text = question.question
        quizStepsLabel.text = question.stepsTextLabel

        self.activityIndicatorShowing(show: false)
        enableControls(true)
    }

    // MARK: - Private methods

    /// Создать игру/рестарт игры
    private func create() {
        activityIndicatorShowing(show: true)

        let questionFactory = QuestionNetworkFactory(client: NetworkClient(), delegate: self)
        questionFactory.load()
        questions = questionFactory
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
            self.activityIndicatorShowing(show: true)
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

        let bestScore = "\(bestScrore.current) (\(bestScrore.completedAt.dateTimeString))"

        alertPresenter.view(
            title: statistic.avgAccuracy == 100 ? "🎉 Победа!" : "Этот раунд окончен",
            message:
                "Ваш результат: \(statistic.current)\n" +
                "Количество сыграных квизов: \(storage.all().count)\n" +
                "Рекорд: \(bestScore)\n" +
                "Средняя точность: \(storage.average().rounded(length: 2))%",
            actions: [
                UIAlertAction(title: "Попробовать еще раз", style: .default) {_ in
                    self.didLoadDataFromServer()
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

<<<<<<< HEAD
        activityIndicator.color = UIColor.accent
        activityIndicator.backgroundColor = UIColor.background
        activityIndicator.layer.cornerRadius = 10
        activityIndicator.isHidden = true
=======
        print("✅ Configured storyboard")
    }
>>>>>>> project_sprint_3_start

        enableControls(false)

<<<<<<< HEAD
        print("✅ Configured storyboard")
=======
        overlay.add(animation, forKey: nil)

        // fix: моргание 🤷‍♂️, не знаю как это должно быть по другому
        // возможно тут и правильно так, типа другой задачей, но не уверен
        DispatchQueue.main.async {
            overlay.backgroundColor = color.withAlphaComponent(alpha).cgColor
        }
    }
}

/**
    The main functionality of the quiz
*/
class Quiz {
    // MARK: - Properties

    var answered = QuizAnswered()
    let beginedAt: Date
    var completedAt: Date?
    var counterLabelText: String?
    var questions: [QuizQuestion] = []

    init() {
        beginedAt = Date()
        questions = getQuestions().shuffled()
        counterLabelText = getTextForStepsLabel()

        print("🎲 Created a new quiz and shuffled the questions.")
    }

    // MARK: - Public methods

    func show() -> QuizStepViewModel? {
        guard let question = getCurrentQuestion() else { return nil }

        return QuizStepViewModel(
            image: UIImage(named: question.image) ?? UIImage(named: "Error"),
            question: question.text,
            stepsTextLabel: getTextForStepsLabel())
    }

    func checkAnswer(answer: Bool) -> Bool? {
        guard let question = getCurrentQuestion() else { return nil }

        let result = checkAnswer(question: question, answer: answer)
        answered.store(question: question, result: result)

        return result
    }

    func getCurrentQuestion() -> QuizQuestion? {
        let currentPosition = answered.position()

        if currentPosition > questions.count - 1 {
            complete(date: Date())
            return nil
        }

        return questions[currentPosition]
    }

    func complete(date: Date) {
        if answered.position() < questions.count - 1 { return }
        self.completedAt = date

        print("🏁 Completed quiz")
    }

    func percentAccuracy() -> Float {
        return Float(answered.successful.count) / Float(questions.count) * 100
    }

    // MARK: - Private methods

    private func checkAnswer(question: QuizQuestion, answer: Bool) -> Bool {
        return question.correctAnswer == answer
    }

    private func getTextForStepsLabel() -> String {
        return "\(answered.position() + 1) / \(questions.count)"
    }

    // MARK: - Mock data

    private func getQuestions() -> [QuizQuestion] {
        return [
            QuizQuestion.init(
                image: "The Godfather",
                rating: 9.2,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "The Dark Knight",
                rating: 9.0,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "Kill Bill",
                rating: 8.1,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "The Avengers",
                rating: 8.0,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "Deadpool",
                rating: 8.0,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "The Green Knight",
                rating: 6.6,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "Old",
                rating: 5.8,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),

            QuizQuestion.init(
                image: "The Ice Age Adventures of Buck Wild",
                rating: 4.3,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),

            QuizQuestion.init(
                image: "Tesla",
                rating: 5.1,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),

            QuizQuestion.init(
                image: "Vivarium",
                rating: 5.8,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
    }
}

/**
    Helper class by score message
*/
class ViewScore {
    // MARK: - Properties

    let currentQuiz: Quiz
    let quizes: [Quiz]

    init(quizes: [Quiz], currentQuiz: Quiz) {
        self.quizes = quizes
        self.currentQuiz = currentQuiz
    }

    // MARK: - Public methods

    func alertComplete(closure: @escaping () -> Void) -> UIAlertController {
        let scoreModel = QuizScoreViewModel(
            title: currentQuiz.answered.successful.count == currentQuiz.questions.count
                ? "🎉 Победа!"
                : "Этот раунд окончен",
            message: message(),
            buttonText: "Попробовать еще раз")

        let alert = UIAlertController(
            title: scoreModel.title,
            message: scoreModel.message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: scoreModel.buttonText,
            style: .default
        ) {_ in
            closure()
        }

        alert.addAction(action)

        return alert
    }

    // MARK: - Private methods

    private func message() -> String {
        guard let lastQuiz = quizes.last else { return "" }
        guard let bestResult = bestResult() else { return "" }
        guard let bestDateString = bestResult.completedAt else { return "" }

        let bestScoreString = [
            "\(bestResult.answered.successful.count)/\(bestResult.questions.count)",
            "(\(bestDateString.dateTimeString))"
        ].joined(separator: " ")

        return [
            "Ваш результат: \(lastQuiz.answered.successful.count)/\(lastQuiz.questions.count)",
            "Количество сыграных квизов: \(quizes.count)",
            "Рекорд: \(bestScoreString)",
            "Средняя точность: \(NSString(format: "%.2f", accuracyAvg()))%"
        ].joined(separator: "\n")
    }

    /// Search the best quiz
    private func bestResult() -> Quiz? {
        guard var bestScore = quizes.first else { return nil }
        for score in quizes where score.answered.successful.count > bestScore.answered.successful.count {
            bestScore = score
        }

        return bestScore
    }

    /// Search for the average accuracy of quizzes
    private func accuracyAvg() -> Float {
        var accuracies: [Float] = []

        for quiz in quizes { accuracies.append(quiz.percentAccuracy()) }

        return accuracies.reduce(0, +) / Float(accuracies.count)
    }
}

// MARK: - Theme

enum StyleDefault {
    static let fontBold = "YSDisplay-Bold"
    static let fontMedium = "YSDisplay-Medium"
    static let fontSize = 20.0
    static let borderWidthShowResult = 8.0
    static let overlayColor = UIColor(
        red: 26 / 255,
        green: 27 / 255,
        blue: 34 / 255,
        alpha: 1)
}

class ThemeUIButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layer.cornerRadius = 15
        tintColor = UIColor.appBackground
        backgroundColor = UIColor.appDefault

        titleLabel?.font = UIFont(
            name: StyleDefault.fontBold,
            size: StyleDefault.fontSize)

        self.titleEdgeInsets = UIEdgeInsets(
            top: 18.0,
            left: 16.0,
            bottom: 18.0,
            right: 16.0)
    }
}

class ThemeUILabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        font = UIFont(
            name: StyleDefault.fontMedium,
            size: StyleDefault.fontSize)
>>>>>>> project_sprint_3_start
    }
}
