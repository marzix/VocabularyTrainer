//
//  AddItemViewController.swift
//  Vocabulary Trainer
//
//  Created by Marzena Kruszy on 4/26/18.
//  Copyright © 2018 Marzena Kruszy. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    
    @IBOutlet weak var inEnglishTextField: UITextField!
    @IBOutlet weak var inSpanishTextField: UITextField!
    @IBOutlet weak var articleControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var word: Word?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        inEnglishTextField.delegate = self
        inSpanishTextField.delegate = self
        
        //Set up views if editing an existing word
        if let editedWord = word {
            inEnglishTextField.text = editedWord.word[0]
            inSpanishTextField.text = editedWord.word[1]
            articleControl.selectedSegmentIndex = editedWord.article == .el ? 0 : 1
        }
        
        UpdateSaveButtonState()
    }
    
    // MARK: - Navigation

    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        
        let presentingInAddItemMode = presentingViewController is UINavigationController
        if presentingInAddItemMode {
            
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("AddItemViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        
        let inEnglish = inEnglishTextField.text ?? ""
        let translation = inSpanishTextField.text ?? ""
        word = Word( inEnglish: inEnglish, translation: [translation], article: articleControl.titleForSegment(at: articleControl.selectedSegmentIndex)! )
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text: String
        
        //Check if the other text field is empty
        let otherTextField = textField === inEnglishTextField ? inSpanishTextField.text : inEnglishTextField.text
        text = otherTextField!
        
        if( !text.isEmpty ) {
        
            //Check if the current edit in text field will result in an empty string
            text = textField.text!
            
            //if all characters were removed
            if( range.length >= text.count && string.isEmpty ) {
                text = ""
            }
            //if the text field is currently empty, the string may not be so swap
            text = text.isEmpty ? string : text
        }
        UpdateSaveButtonState(text)
        return true
    }
    
    //MARK: Actions
    
    @IBAction func ArticleChanged(_ sender: UISegmentedControl) {
        
        UpdateSaveButtonState()
    }
    
    //MARK: Private functions
    
    private func UpdateSaveButtonState() {
        
        var text = inEnglishTextField.text ?? ""
        if( !text.isEmpty ) {
            text = inSpanishTextField.text ?? ""
        }
        UpdateSaveButtonState( text )
    }
    
    private func UpdateSaveButtonState(_ newString: String?) {
        
        guard newString != nil else {
            saveButton.isEnabled = false
            return
        }
        let string: String = newString!
        saveButton.isEnabled = !string.isEmpty && articleControl.selectedSegmentIndex != -1
    }
}
