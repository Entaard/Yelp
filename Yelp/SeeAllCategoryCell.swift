//
//  SeeAllCategoryCell.swift
//  Yelp
//
//  Created by Enta'ard on 10/23/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class SeeAllCategoryCell: UITableViewCell {

    @IBOutlet weak var seeAllLabel: UILabel!
    
    var showSeeAll = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
