//
//  ViewController.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 13/11/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Search controlls
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        // Filter paper objects according to needs
    
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        self.filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTableView.dataSource = self
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.searchTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "ST1", "ST2", "PUT", "UT"]
        searchController.searchBar.delegate = self
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if !launchedBefore {
            self.activityIndicator.startAnimating()
            // Call get all papers endpoint and populate db
            APIManager.sharedInstance.delegate = self
            APIManager.sharedInstance.getAllPapers()
        
            UserDefaults.standard.set(true, forKey: "launchedBefore")

        }
        

    }

}


// MARK: Table View datasource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "search-cell")
        cell?.textLabel?.text = "Blah"
        return cell!
    }
}

extension SearchViewController: APIManagerDelegate {
    func didFinishTask() {
        // do stuff like updating the UI
        print("this always happens afterwards")
        self.activityIndicator.isHidden = true
    }
}


