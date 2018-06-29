//
//  MainMenuViewController.swift
//  Vocabulary Trainer
//
//  Created by Marzena Kruszy on 4/25/18.
//  Copyright © 2018 Marzena Kruszy. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func UnwindToMainMenu( sender: UIStoryboardSegue ) {
        if sender.source is PopOverViewController {
            
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "StartTraining" {
            
            TrainingViewController.trainingInstance.wordIndex = [2, 0, 1]
        }
        else  {
            print( "\(segue.destination)" )
        }
    }
}
