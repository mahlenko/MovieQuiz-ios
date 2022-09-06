import UIKit

/**
    View controller Movie Quiz App
*/
final class MovieQuizViewController: UIViewController {
    // MARK: - Properties

    private var storage: StatisticServiceProtocol = StatisticDefaultService()

    private let scoreView: AlertFactoryProtocol = AlertFactory()

    private var quiz: QuizModel?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Outlets

    @IBOutlet internal var viewContainer: UIView!
    @IBOutlet private weak var quizStepsLabel: UILabelTheme!
    @IBOutlet internal weak var quizImageView: UIImageView!
    @IBOutlet internal weak var quizQuestionLabel: UILabel!
    @IBOutlet internal weak var falseButton: UIButtonTheme!
    @IBOutlet internal weak var trueButton: UIButtonTheme!

    // MARK: - Actions

    @IBAction private func falseButtonClicked(_ sender: Any) {
        checkAnswer(answer: false)
    }

    @IBAction private func trueButtonClicked(_ sender: Any) {
        checkAnswer(answer: true)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        createQuiz()
    }

    // MARK: - Private methods

    /// Creating new quiz (start/continue)
    private func createQuiz() {
        quiz = QuizModel()
        showNextQuestion()
    }

    private func showNextQuestion() {
        guard let question = quiz?.nextQuestion() else { return }
        show(question: question)
    }

    /// Show the quiz on the screen
    private func show(question: QuizStepViewModel) {
        quizImageView.image = question.image
        quizQuestionLabel.text = question.question
        quizStepsLabel.text = question.stepsTextLabel
    }

    private func checkAnswer(answer: Bool) {
        guard let quiz = quiz else { return }

        enableControls(false)

        if let isCorrectResult = quiz.checkAnswer(answer: answer) {
            isCorrectResult ? successImageView() : failedImageView()
        }

        // Go to the next question or wait for results with a delay of 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.enableControls(true)
            self.setImageBorderView()
            quiz.isComplete() ? self.completeQuiz(quiz: quiz) : self.showNextQuestion()
        }
    }

    /// Closed this quiz
    private func completeQuiz(quiz: QuizModel) {
        // Save complete quiz
        let statistic = StatisticViewModel(
            current: quiz.resultText(),
            avgAccuracy: quiz.percentAccuracy(),
            completedAt: Date()
        )

        self.storage.store(statistic: statistic)

        scoreView.show(
            delegate: self,
            ScoreAlertViewModel(storage: storage) { [self] in createQuiz() })
    }
}
