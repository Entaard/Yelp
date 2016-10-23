//
//  SearchCondition.swift
//  Yelp
//
//  Created by Enta'ard on 10/21/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import Foundation

class SearchCondition {
    
    var term: String = ""
    var sort: YelpSortMode?
    var categories: [String]?
    var deals: Bool?
    var distanceInMeter: Float?
    var offset: Int = 0
    
    // for display
    var selectedDistanceName: String?
    var selectedCategories: [Int: Bool]?
    
    static let sharedInstance: SearchCondition = {
        let singleton = SearchCondition()
        singleton.sort = nil
        singleton.categories = [String]()
        singleton.deals = nil
        singleton.distanceInMeter = nil
        singleton.selectedCategories = nil
        
        return singleton
    }()
    
}
