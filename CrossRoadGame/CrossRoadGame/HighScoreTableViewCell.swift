//
//  HighScoreTableCellView.swift
//  CrossRoadGame
//
//  Created by Sam  Sedziol on 4/14/22.
//
// CrossRoadGame
// 5/5/22 7:20pm
// Wyatt Roberson wyarober
// Sam Sedziol ssedziol
// Ethan Tang ewtang

import UIKit

class HighScoreTableViewCell: UITableViewCell {
    
    //cell contents
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
