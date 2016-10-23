//
//  FilterDealCell.swift
//  Yelp
//
//  Created by Enta'ard on 10/20/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol FilterDealCellDelegate {
    
    @objc func filterDealCell(_ filterDealCell: FilterDealCell, onSwitchChanged switchValue: Bool)
    
}

class FilterDealCell: UITableViewCell {
    
    @IBOutlet weak var switchBtn: UISwitch!
    
    weak var delegate: FilterDealCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func onSwitched(_ sender: UISwitch) {
        delegate?.filterDealCell(self, onSwitchChanged: switchBtn.isOn)
    }
    
}
