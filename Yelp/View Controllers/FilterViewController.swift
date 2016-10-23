//
//  FilterViewController.swift
//  Yelp
//
//  Created by Enta'ard on 10/21/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    
    @objc func filterViewController(_ filterViewController: FilterViewController)
    
}

class FilterViewController: UIViewController {
    
    let rowHeight: CGFloat = 44
    let headerHeight: CGFloat = 48
    let distanceLabelNames = Constant.distanceLabelNames
    let distances = Constant.distances
    let sortModeLabelnames = Constant.sortModeLabelnames
    let categories = Constant.categories
    
    @IBOutlet weak var filterTableView: UITableView!
    
    var hasDeal = SearchCondition.sharedInstance.deals ?? false
    var distanceViewExpanded = false
    var selectedDistance = SearchCondition.sharedInstance.selectedDistanceName ?? Constant.distanceLabelNames[0]
    var distanceInMeter: Float?
    var delegate: FilterViewControllerDelegate?
    var sortViewExpanded = false
    var selectedSortMode = SearchCondition.sharedInstance.sort ?? YelpSortMode.bestMatched
    var categoryViewExpanded = false
    var selectedCategories = SearchCondition.sharedInstance.selectedCategories ?? [Int: Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.reloadData()
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: UIBarButtonItem) {
        SearchCondition.sharedInstance.offset = 0
        SearchCondition.sharedInstance.deals = hasDeal
        SearchCondition.sharedInstance.distanceInMeter = distanceInMeter
        SearchCondition.sharedInstance.selectedDistanceName = selectedDistance
        SearchCondition.sharedInstance.sort = selectedSortMode
        SearchCondition.sharedInstance.categories = [String]()
        for (key, isSelected) in selectedCategories {
            if isSelected {
                SearchCondition.sharedInstance.categories?.append(categories[key]["code"]!)
            }
        }
        SearchCondition.sharedInstance.selectedCategories = selectedCategories
        
        delegate?.filterViewController(self)
        dismiss(animated: true, completion: nil)
    }
    
    func convertToMeter(mile: Float?) -> Float? {
        guard mile != nil else {
            return nil
        }
        return mile! * Constant.mileToMeter
    }
    
    func checkSelectedCategory() -> Bool {
        guard selectedCategories.count > 0 else {
            return false
        }
        
        for category in selectedCategories {
            if category.value {
                return true
            }
        }
        return false
    }
    
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return distances.count + 1
        case 2:
            return sortModeLabelnames.count + 1
        case 3:
            return categories.count + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return rowHeight
        case 1:
            if indexPath.row == 0 {
                return rowHeight
            } else {
                guard distanceViewExpanded else {
                    return 0
                }
                return rowHeight
            }
        case 2:
            if indexPath.row == 0 {
                return rowHeight
            } else {
                guard sortViewExpanded else {
                    return 0
                }
                return rowHeight
            }
        case 3:
            // If there are some selecting categories, show them
            if checkSelectedCategory() {
                for (index, isSelected) in selectedCategories {
                    if isSelected && indexPath.row == index {
                        return rowHeight
                    }
                }
                // else show 3 first row
            } else {
                if indexPath.row < 3 {
                    return rowHeight
                }
            }
            
            // always show the last row (see more row)
            if indexPath.row == categories.count {
                return rowHeight
            }
            
            // if category view is expanding - > show all. Else no
            guard categoryViewExpanded else {
                return 0
            }
            return rowHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterDealCell") as! FilterDealCell
            cell.switchBtn.isOn = hasDeal
            cell.delegate = self
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilterShowDistanceCell") as! FilterShowDistanceCell
                cell.selectedDistance.text = selectedDistance
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSelectDistanceCell") as! FilterSelectDistanceCell
                cell.optionDistance.text = distanceLabelNames[indexPath.row - 1]
//                if cell.optionDistance.text == selectedDistance {
//                    cell.checkMarkImg.isHidden = false
//                } else {
//                    // This simple line can fix the problem of reusable cell :)))
//                    cell.checkMarkImg.isHidden = true
//                }
                cell.checkMarkImg.isHidden = cell.optionDistance.text != selectedDistance
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilterShowSortCell") as! FilterShowSortCell
                cell.selectedSortMode.text = sortModeLabelnames[selectedSortMode.rawValue]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSelectSortCell") as! FilterSelectSortCell
                cell.SortMode.text = Constant.sortModeLabelnames[indexPath.row - 1]
                cell.checkMarkImg.isHidden = cell.SortMode.text != sortModeLabelnames[selectedSortMode.rawValue]
                return cell
            }
        case 3:
            if indexPath.row == categories.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllCategoryCell") as! SeeAllCategoryCell
                if !categoryViewExpanded {
                        cell.seeAllLabel.text = "See All"
                } else {
                    cell.seeAllLabel.text = "Hide"
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCategoryCell") as! FilterCategoryCell
                cell.delegate = self
                cell.categoryLabel.text = categories[indexPath.row]["name"]
                cell.switchBtn.isOn = selectedCategories[indexPath.row] ?? false
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 1:
            if indexPath.row == 0 {
                distanceViewExpanded = !distanceViewExpanded
            } else {
                selectedDistance = distanceLabelNames[indexPath.row - 1]
                let mileValue = distances[selectedDistance]
                distanceInMeter = convertToMeter(mile: mileValue!)
                distanceViewExpanded = false
            }
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            break
        case 2:
            if indexPath.row == 0 {
                sortViewExpanded = !sortViewExpanded
            } else {
                let selectedModeNumber = indexPath.row - 1
                switch selectedModeNumber {
                case 1:
                    selectedSortMode = YelpSortMode.distance
                case 2:
                    selectedSortMode = YelpSortMode.highestRated
                default:
                    selectedSortMode = YelpSortMode.bestMatched
                }
                sortViewExpanded = false
            }
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            break
        case 3:
            guard indexPath.row == categories.count else {
                break
            }
            categoryViewExpanded = !categoryViewExpanded
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            break
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else {
            return 0
        }
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight))
        headerView.backgroundColor = UIColor.orange
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: headerView.bounds.width, height: 30))
        
        switch section {
        case 0:
            label.text = ""
        case 1:
            label.text = "Distance"
        case 2:
            label.text = "Sort by"
        case 3:
            label.text = "Category"
        default:
            label.text = ""
        }
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        headerView.addSubview(label)
        
        return headerView
    }
    
}

extension FilterViewController: FilterDealCellDelegate {
    
    func filterDealCell(_ filterDealCell: FilterDealCell, onSwitchChanged switchValue: Bool) {
        hasDeal = switchValue
    }
    
}

extension FilterViewController: FilterCategoryCellDelegate {
    
    func filterCategoryCell(_ filterCategoryCell: FilterCategoryCell, onSwitchChanged switchValue: Bool) {
        let indexPath = filterTableView.indexPath(for: filterCategoryCell)
        selectedCategories[(indexPath?.row)!] = switchValue
    }
    
}
