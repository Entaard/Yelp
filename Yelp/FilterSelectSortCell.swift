//
//  FilterSelectSortCell.swift
//  Yelp
//
//  Created by Enta'ard on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class FilterSelectSortCell: UITableViewCell {

    @IBOutlet weak var SortMode: UILabel!
    @IBOutlet weak var checkMarkImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
