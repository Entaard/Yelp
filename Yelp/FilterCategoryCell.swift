//
//  FilterCategoryCell.swift
//  Yelp
//
//  Created by Enta'ard on 10/23/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol FilterCategoryCellDelegate {
    
    @objc func filterCategoryCell(_ filterCategoryCell: FilterCategoryCell, onSwitchChanged switchValue: Bool)
    
}

class FilterCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    weak var delegate: FilterCategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func onSwitch(_ sender: UISwitch) {
        delegate?.filterCategoryCell(self, onSwitchChanged: switchBtn.isOn)
    }
}
