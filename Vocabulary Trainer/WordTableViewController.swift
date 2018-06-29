//
//  WordTableViewController.swift
//  Vocabulary Trainer
//
//  Created by Marzena Kruszy on 4/25/18.
//  Copyright © 2018 Marzena Kruszy. All rights reserved.
//

import UIKit
import os.log

class WordTableViewController: UITableViewController {

    //MARK: Properties
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    let dictionaryRef = Dictionary.singleton
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setToolbarItems([editButtonItem], animated: false)
        navigationController?.setToolbarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dictionaryRef.GetSize()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell", for: indexPath) as? WordTableViewCell else {
            fatalError("The dequeued cell is not as instance of WordTableViewCell")
        }
        let selectedWord = dictionaryRef.GetWord(at: indexPath.row)
        
        cell.wordLabel.text = selectedWord.word[0]
        let proficiency: Double = Double(selectedWord.proficiency[0])/Double(selectedWord.proficiency[1]) * 100.0
        cell.translationLabel.text = selectedWord.article.rawValue + " " + selectedWord.word[1]
        cell.proficiencyLabel.text = selectedWord.proficiency[1] == 0 ? "0%" : "\(Int(proficiency))%"

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            dictionaryRef.RemoveWord(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        tableView.moveRow(at: fromIndexPath, to: to)
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch( segue.identifier ?? "" )
        {
        case "AddItem":
            os_log("Add new item")
        case "EditItem":
            guard let detailsViewController = segue.destination as? AddItemViewController else {
                fatalError("Unexpected destination: \(segue.destination) in WordTableViewController")
            }
            
            guard let selectedWordCell = sender as? WordTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender)) in WordTableViewController")
            }
            
            guard let cellIndex = tableView.indexPath(for: selectedWordCell) else {
                fatalError("Selected cell is not being displayed by the table")
            }
            
            let selectedWord = dictionaryRef.GetWord(at: cellIndex.row)
            detailsViewController.word = selectedWord
        default:
            guard segue.destination is MainMenuViewController else {
                fatalError("Unexpected segue identifier: \(segue) in WordTableViewController")
            }
        }
    }
    
    //MARK: Actions
    
    @IBAction func UnwindToDictionary( sender: UIStoryboardSegue ) {
        
        if let sourceViewController = sender.source as? AddItemViewController, let word = sourceViewController.word {
            
            //word is being edited
            if let selectedCellIndex = tableView.indexPathForSelectedRow {
                
                let index = dictionaryRef.MoveWord(fromIndex: selectedCellIndex.row)
                if index != -1 {
                    let newIndexPath = IndexPath(row: index, section: 0)
                    tableView.moveRow(at: selectedCellIndex, to: newIndexPath)
                }
            }
            //new word is being added
            else {
                
                let index = dictionaryRef.InsertWord(newWord: word)
                if index != -1 {
                    let newIndexPath = IndexPath(row: index, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        }
    }
}
