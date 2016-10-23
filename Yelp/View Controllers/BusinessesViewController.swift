//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController {

    @IBOutlet weak var businessTableView: UITableView!
    @IBOutlet weak var scrollTopBtn: UIButton!
    
    var searchCondition: SearchCondition!
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var refreshControl: UIRefreshControl!
    var isLoadingMoreData = false
    var initScrollOffsetThreshold: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        
        searchCondition = SearchCondition.sharedInstance
        searchCondition.term = ""
        doSearch(withHUD: true)
    }
    
    @IBAction func scrollTop(_ sender: UIButton) {
        let indexPathOfFirstRow = IndexPath(row: 0, section: 0)
        businessTableView.scrollToRow(at: indexPathOfFirstRow, at: .top, animated: true)
        sender.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier =  segue.identifier
        let navigationController = segue.destination as! UINavigationController
        let navBar = navigationController.navigationBar
        navBar.tintColor = UIColor.orange
        if identifier == "FilterViewNavigator" {
            let filterViewController = navigationController.topViewController as! FilterViewController
            filterViewController.delegate = self
        } else if identifier == "DetailViewNavigator" {
            let businessDetailViewController = navigationController.topViewController as! BusinessDetailViewController
            let indexPath = businessTableView.indexPathForSelectedRow
            businessDetailViewController.business = businesses[(indexPath?.row)!]
        }
    }
    
    func doSearch(withHUD: Bool) {
        if withHUD {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        searchCondition.term = searchBar.text!
        
        Business.search(withConditions: searchCondition) { (businesses: [Business]?, error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                self.businessTableView.reloadData()
                
                // get init scroll offset for scrollTop func
                let initScrollViewContentHeight = self.businessTableView.contentSize.height
                self.initScrollOffsetThreshold = initScrollViewContentHeight - self.businessTableView.bounds.height
                
                if withHUD {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                self.refreshControl.endRefreshing()
                
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(business.imageURL?.absoluteString)
                    print(business.coordinate)
                }
            }
            
            if let error = error {
                print(error)
            }
        }
    }
    
    func loadMore() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        searchCondition.offset = businesses.count
        
        Business.search(withConditions: searchCondition) { (moreBusinesses, error) in
            if let moreBusinesses = moreBusinesses {
                self.businesses.append(contentsOf: moreBusinesses)
                self.businessTableView.reloadData()
                
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            if let error = error {
                print(error)
            }
            
            self.isLoadingMoreData = false
        }
    }
    
    private func initViews() {
        navigationController?.navigationBar.tintColor = UIColor.orange
        
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 130
        
        businessTableView.dataSource = self
        businessTableView.delegate = self
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.text = ""
        
        scrollTopBtn.isHidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(BusinessesViewController.doSearch(withHUD:)), for: UIControlEvents.valueChanged)
        businessTableView.insertSubview(refreshControl, at: 0)
    }

}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard businesses != nil else {
            return 0
        }
        
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
}

extension BusinessesViewController: FilterViewControllerDelegate {
    
    func filterViewController(_ filterViewController: FilterViewController) {
        doSearch(withHUD: true)
    }
    
}

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        doSearch(withHUD: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        doSearch(withHUD: true)
    }
    
}

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollTopBtn.isHidden = !(businessTableView.contentOffset.y > initScrollOffsetThreshold)
        
        if !isLoadingMoreData {
            let scrollViewContentHeight = businessTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - businessTableView.bounds.height
            
            if businessTableView.contentOffset.y > scrollOffsetThreshold && businessTableView.isDragging {
                isLoadingMoreData = true
                loadMore()
            }
        }
    }
    
}
