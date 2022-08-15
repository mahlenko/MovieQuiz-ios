import UIKit

/**
    View controller Movie Quiz App
*/
final class MovieQuizViewController: UIViewController {
    // MARK: - Properties

    var store: [Quiz] = []
    var quiz = Quiz()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - IBOutlets

    @IBOutlet private var viewContainer: UIView!
    @IBOutlet private weak var quizStepsLabel: UILabelTheme!
    @IBOutlet private weak var quizImageView: UIImageView!
    @IBOutlet private weak var quizQuestionLabel: UILabel!
    @IBOutlet private weak var falseButton: UIButtonTheme!
    @IBOutlet private weak var trueButton: UIButtonTheme!

    // MARK: - IBActions

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let firstQuestion = quiz.nextQuestion() else { return }
        show(question: firstQuestion)
    }

    // MARK: - Private methods

    /// Creating new quiz (start/continue)
    private func createQuiz() {
        quiz = Quiz()

        guard let firstQuestion = quiz.nextQuestion() else { return }
        show(question: firstQuestion)
    }

    /// Show the quiz on the screen
    private func show(question: QuizStepViewModel) {
        quizImageView.image = question.image
        quizQuestionLabel.text = question.question
        quizStepsLabel.text = question.stepsTextLabel

        print(String("Showed a quiz question #\(self.quiz.answered.position() + 1)"))
    }

    private func checkAnswer(answer: Bool) {
        enableButtons(enable: false)

        let isCorrectResult = quiz.checkAnswer(answer: answer)

        if isCorrectResult == true {
            showSuccessImageView()
            print("🎉 The answer is correct")
        } else if isCorrectResult == false {
            showFailedImageView()
            print("😔 The answer is NOT correct")
        }

        // Go to the next question or wait for results with a delay of 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.enableButtons(enable: true)
            self.setImageBorderView()

            if self.quiz.isComplete() {
                self.completeQuiz(quiz: self.quiz)
            } else {
                guard let nextQuestion = self.quiz.nextQuestion() else { return }
                self.show(question: nextQuestion)
            }
        }
    }

    /// Showing alert message scrore
    private func showScore(quiz: Quiz) {
        let score = ViewScore(store: store, quiz: quiz, delegate: self)

        score.alertComplete {
            self.createQuiz()
        }
    }

    /// Closed this quiz
    private func completeQuiz(quiz: Quiz) {
        quiz.complete(date: Date())

        self.storeScore(quiz: quiz)
        self.showScore(quiz: quiz)
    }

    private func storeScore(quiz: Quiz) {
        self.store.append(quiz)
    }

    private func setImageBorderView(color: UIColor? = .none, width: CGFloat = .nan) {
        self.quizImageView.layer.borderColor = color?.cgColor
        self.quizImageView.layer.borderWidth = width
    }

    private func showSuccessImageView() {
        return setImageBorderView(
            color: UIColor.appSuccess,
            width: StyleDefault.borderWidthShowResult)
    }

    private func showFailedImageView() {
        return setImageBorderView(
            color: UIColor.appFail,
            width: StyleDefault.borderWidthShowResult)
    }

    private func enableButtons(enable: Bool) {
        trueButton.isEnabled = enable
        falseButton.isEnabled = enable
    }

    private func configuration() {
        viewContainer.backgroundColor = UIColor.appBackground
        quizImageView.layer.cornerRadius = 20
        quizQuestionLabel.font = UIFont(name: StyleDefault.fontBold, size: 23.0)

        print("✅ Configurated storyboard")
    }
}
