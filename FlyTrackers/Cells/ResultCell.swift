//
//  ResultCell.swift
//  FlyTrackers
//
//  Created by Elliott Larsen on 3/20/22.
//

import UIKit

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var flightView: UIImageView!
    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var ETALabel: UILabel!
    
    var flight: Flight! {
        didSet {
            airlineLabel.text = flight.airline
            flightNumberLabel.text = flight.flightNumberICAO
            ETALabel.text = flight.getTimeToArrival()
        }

    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
