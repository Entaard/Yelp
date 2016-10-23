//
//  BusinessCell.swift
//  Yelp
//
//  Created by Enta'ard on 10/20/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingStarView: UIImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business: Business! {
        didSet {
            // TODO: add default img
            if business.imageURL != nil {
                imgView.setImageWith(business.imageURL!)
            }
            nameLabel.text = business.name
            distanceLabel.text = business.distance!
            // TODO: add default img
            if business.ratingImageURL != nil {
                ratingStarView.setImageWith(business.ratingImageURL!)
            }
            ratingCountLabel.text = String(format: "%.0f Reviews", business.reviewCount as! Float)
            addressLabel.text = business.address
            categoryLabel.text = business.categories
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
