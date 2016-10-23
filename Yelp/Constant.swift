//
//  Constant.swift
//  Yelp
//
//  Created by Enta'ard on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import Foundation

enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated
}

struct Constant {
    
    static let distanceLabelNames = ["auto", "0.3 mile", "1 mile", "5 miles", "20 miles"]
    static let distances: [String: Float?] = [
        distanceLabelNames[0]: nil,
        distanceLabelNames[1]: 0.3,
        distanceLabelNames[2]: 1,
        distanceLabelNames[3]: 5,
        distanceLabelNames[4]: 20
    ]
    static let mileToMeter: Float = 1609.34
    static let sortModeLabelnames = ["Best matched", "Distance", "Highest Rated"]
    static let categories: [Dictionary<String, String>] = [
        ["name" : "Afghan", "code": "afghani"],
        ["name" : "African", "code": "african"],
        ["name" : "American, New", "code": "newamerican"],
        ["name" : "American, Traditional", "code": "tradamerican"],
        ["name" : "Arabian", "code": "arabian"],
        ["name" : "Argentine", "code": "argentine"],
        ["name" : "Armenian", "code": "armenian"],
        ["name" : "Asian Fusion", "code": "asianfusion"],
        ["name" : "Asturian", "code": "asturian"],
        ["name" : "Australian", "code": "australian"],
        ["name" : "Austrian", "code": "austrian"],
        ["name" : "Bangladeshi", "code": "bangladeshi"],
        ["name" : "Venison", "code": "venison"],
        ["name" : "Vietnamese", "code": "vietnamese"]
    ]
    
}
