//
//  PopOverViewController.swift
//  Vocabulary Trainer
//
//  Created by Marzena Kruszy on 4/25/18.
//  Copyright © 2018 Marzena Kruszy. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var scoreLabel: UILabel!


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard parent is TrainingViewController else {
            return
        }
        scoreLabel.text = "Core: \(TrainingViewController.trainingInstance.rightAnswers)/\(TrainingViewController.trainingInstance.wordIndex.count)"

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Animation
    
    func ShowAnimate() {
        
    }
    
    func RemoveAnimate() {
        
    }
    
    //MARK: Actions
    
    @IBAction func ContinueButtonPressed(_ sender: Any) {
        //self.view.removeFromSuperview()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
