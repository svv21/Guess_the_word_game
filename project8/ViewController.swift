import UIKit

class ViewController: UIViewController {
    var scoreLabel: UILabel!
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var solvedWords = [String]()
    
    var level: Int = 1
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.numberOfLines = 0
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.placeholder = "Tap letters to guess"
        view.addSubview(currentAnswer)
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTaped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        let clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonTaped), for: .touchUpInside)
        view.addSubview(clearButton)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.cornerRadius = 8
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 150
        let height = 80
        
        for row in 0...3 {
            for col in 0...4 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = .systemFont(ofSize: 36)
                letterButton.setTitle("WoW", for: .normal)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterButtonTaped), for: .touchUpInside)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL, encoding: .utf8) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let part = line.components(separatedBy: ": ")
                    let answer = part[0]
                    let clue = part[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                    letterBits.shuffle()
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if letterBits.count == letterButtons.count {
            for i in 0..<letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func updateLevel(action: UIAlertAction) {
        level += 1
        
        if level == 3 {
            let alert = UIAlertController(title: "That's all!", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                self.solutions.removeAll(keepingCapacity: true)
                self.letterButtons.forEach { $0.isHidden = true }
                self.cluesLabel.text = nil
                self.answersLabel.text = nil
            }
            )
            
            alert.addAction(action)
            present(alert, animated: true)
        }
        
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        letterButtons.forEach { $0.isHidden = false }
    }
    
    @objc func submitButtonTaped(_ sender: UIButton) {
        guard let answer = currentAnswer.text else { return }
        
        if let position = solutions.firstIndex(of: answer) {
            solvedWords.append(answer)
            activatedButtons.removeAll()
            
            var array = answersLabel.text?.components(separatedBy: "\n")
            array?[position] = answer
            let joinedArray = array?.joined(separator: "\n")
            answersLabel.text = joinedArray
            
            currentAnswer.text = ""
            score += 1
            
            if solvedWords.count % 7 == 0 {
                let alert = UIAlertController(title: "You are win!", message: "Congratulations, you can continue!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: updateLevel)
                alert.addAction(action)
                present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Wrong answer!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                self.activatedButtons.forEach { button in
                    button.isHidden = false
                }
                self.currentAnswer.text = ""
                self.score -= 1
            }))
            present(alert, animated: true)
        }
    }


@objc func clearButtonTaped(_ sender: UIButton) {
    currentAnswer.text = ""
    
    activatedButtons.forEach { button in
        button.isHidden = false}
    
    activatedButtons.removeAll()
}


@objc func letterButtonTaped(_ sender: UIButton) {
    guard let buttonTitle = sender.titleLabel?.text else { return }
    currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
    activatedButtons.append(sender)
    sender.isHidden = true
}

}

