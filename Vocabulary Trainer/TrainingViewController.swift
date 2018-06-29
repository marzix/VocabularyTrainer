//
//  TrainingViewController.swift
//  Vocabulary Trainer
//
//  Created by Marzena Kruszy on 3/6/18.
//  Copyright © 2018 Marzena Kruszy. All rights reserved.
//

import UIKit

class TrainingViewController: UIViewController, UITextFieldDelegate {

    struct TrainingInstance {
        
        var wordIndex = [Int]()
        var currentQuestion = 0
        var rightAnswers = 0
    }
    
    //MARK: Properties
    
    //---QuestionView
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var articleControl: UISegmentedControl!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var QuitButton: UIBarButtonItem!
    @IBOutlet weak var inEnglishLabel: UILabel!
    
    //---ResultView
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var viewTrailingConstr: NSLayoutConstraint!
    @IBOutlet weak var viewLeadingConstr: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstr: NSLayoutConstraint!
    
    
    //---Statics
    static var trainingInstance = TrainingInstance()
    static let questionText = "How do you say"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        answerTextField.delegate = self
        
        UpdateCheckButtonState()
        
        if TrainingViewController.trainingInstance.wordIndex.count > 0 {
            
            TrainingViewController.trainingInstance.currentQuestion = 0
            TrainingViewController.trainingInstance.rightAnswers = 0
            PrepareNextQuestion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        HideResultView()
    }
    
    //MARK: Private Functions
    
    private func PrepareNextQuestion() {
        
        let TI = TrainingViewController.trainingInstance
        questionLabel.text = TrainingViewController.questionText
        inEnglishLabel.text = Dictionary.singleton.GetWord( at: TI.wordIndex[TI.currentQuestion] ).word[0]
    }
    
    private func UpdateCheckButtonState() {
        
        UpdateCheckButtonState(answerTextField.text)
    }
    
    private func UpdateCheckButtonState(_ newString: String?) {
        
        guard newString != nil else {
            checkButton.isEnabled = false
            return
        }
        let string: String = newString!
        checkButton.isEnabled = !string.isEmpty && articleControl.selectedSegmentIndex != -1
    }
    
    private func HideResultView() {
        
        self.viewTopConstr.constant = self.view.bounds.height / 2
        self.viewLeadingConstr.constant = self.view.bounds.width / 2
        self.viewTrailingConstr.constant = -self.view.bounds.width / 2
        resultView.isHidden = true
        continueButton.alpha = 0
        continueButton.isEnabled = false
    }
    
    private func RefreshView() {
    
        TrainingViewController.trainingInstance.currentQuestion += 1
        if( TrainingViewController.trainingInstance.currentQuestion >= TrainingViewController.trainingInstance.wordIndex.count) {
            
            GameOver()
            return
        }
        PrepareNextQuestion()
        articleControl.selectedSegmentIndex = -1
        answerTextField.text = ""
        UpdateCheckButtonState()
    }
    
    private func GameOver() {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopOver") as! PopOverViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        answerTextField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Check if the current edit in text field will result in an empty string
        var text: String = answerTextField.text!
        if( range.length >= text.count && string.isEmpty ) {
            text = ""
        }
        UpdateCheckButtonState(text.isEmpty ? string : text)
        return true
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
    }
    
    func ShowSolution() {
        
        self.resultView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.viewTopConstr.constant = 36
            self.viewLeadingConstr.constant = 15
            self.viewTrailingConstr.constant = -15
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.continueButton.isEnabled = true
        })
        continueButton.alpha = 1
    }
    
    //MARK: Actions
    
    @IBAction func CheckSolutionAction(_ sender: UIButton) {
        
        var TI = TrainingViewController.trainingInstance
        let currentWord = Dictionary.singleton.GetWord(at: TI.wordIndex[TI.currentQuestion])
        
        resultLabel.text = ""
        correctionLabel.text = "Correct solution: " + currentWord.article.rawValue + " " + currentWord.word[1]
        
        if( articleControl.titleForSegment(at: articleControl.selectedSegmentIndex) != currentWord.article.rawValue ) {
            
            resultLabel.text = "Wrong article"
        }
        if( answerTextField.text?.lowercased() != currentWord.word[1] ) {
           
            resultLabel.text = "Wrong answer"
        }
        if( resultLabel.text?.isEmpty )! {
            resultLabel.text = "Correct!"
            correctionLabel.text = ""
            currentWord.proficiency[0] += 1
            TI.rightAnswers += 1
        }
        currentWord.proficiency[1] += 1
        TrainingViewController.trainingInstance = TI
        Dictionary.singleton.ReplaceWord(at: TI.wordIndex[TI.currentQuestion], with: currentWord)
        
        ShowSolution()
    }
    
    @IBAction func ContinueButtonPressed(_ sender: UIButton) {
        
        continueButton.isEnabled = false
        
        self.RefreshView()
        UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.viewTopConstr.constant = self.view.bounds.height / 2
            self.viewLeadingConstr.constant = self.view.bounds.width / 2
            self.viewTrailingConstr.constant = -self.view.bounds.width / 2
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.HideResultView()
        } )
    }

    
    @IBAction func ArticleChanged(_ sender: Any) {
        
        UpdateCheckButtonState()
    }
}

