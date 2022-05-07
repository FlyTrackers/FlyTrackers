//
//  FavoriteCell.swift
//  FlyTrackers
//
//  Created by Christian Franklin on 5/7/22.
//

import UIKit
import Foundation
import Parse
import SwiftyJSON

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var ETALabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited:Bool = true
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

    @IBAction func favoriteFlight(_ sender: Any) {
        let toBeFavorited = favorited
        if (toBeFavorited) {
            self.setFavorite(false)
        } else {
            self.setFavorite(true)
        }
    }
    
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named:"Results"), for: UIControl.State.normal)

            let parseAPI = ParseAPICaller()
            parseAPI.saveFlightData(user: PFUser.current()!,  flightData: flight, completion: { result in
                 switch result {
                 case .success(_):
                        print("Favorite successful")
                 case .failure(_):
                        print("Favorite unsuccessful")
                 }
             })
        } else {
            favButton.setImage(UIImage(named:"Favorited"), for: UIControl.State.normal)
        }
    }
    
    
}


