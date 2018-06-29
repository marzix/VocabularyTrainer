//
//  WordTableViewCell.swift
//  Vocabulary Trainer
//
//  Created by Marzena Kruszy on 4/25/18.
//  Copyright © 2018 Marzena Kruszy. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    //MARK:Properties
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var proficiencyLabel: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
