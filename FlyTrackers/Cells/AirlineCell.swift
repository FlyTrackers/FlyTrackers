//
//  AirlineCell.swift
//  FlyTrackers
//
//  Created by Giovanni Propersi on 5/14/22.
//

import UIKit

class AirlineCell: UITableViewCell {

    @IBOutlet weak var airlineName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
