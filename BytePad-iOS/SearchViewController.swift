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
    @IBOutlet weak var loadingTextLabel: UILabel!
    
    var papers: [Paper] = []
    
    
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

    func showLoading() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        self.loadingTextLabel.isHidden = false
        self.searchTableView.isHidden = true
    }
    
    func hideLoading() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.loadingTextLabel.isHidden = true
        self.searchTableView.isHidden = false
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
        
//        if !launchedBefore {
        
            self.showLoading()
            
            // Call get all papers endpoint and populate db
            APIManager.sharedInstance.delegate = self
            APIManager.sharedInstance.getAllPapers()
        
            UserDefaults.standard.set(true, forKey: "launchedBefore")

//        }
    }
}


// MARK: Table View datasource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.papers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "search-cell")
        let paper = self.papers[indexPath.row]
        cell?.textLabel?.text = paper.fileURL
        return cell!
    }
}

extension SearchViewController: APIManagerDelegate {
    func didFinishTask() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            self.papers = try context.fetch(Paper.createFetchRequest())
            self.searchTableView.reloadData()
        }
        catch {
            print("Fetching failed")
        }
        
        
        self.hideLoading()

    }
}


