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
    var filteredPapers: [Paper] = []
    
    
    // MARK: Search controlls
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        print(searchText)
        
        self.filteredPapers = papers.filter {
            paper in
            return paper.name!.lowercased().contains(searchText.lowercased())
        }
        
        self.searchTableView.reloadData()
    
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
    
    func loadData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            self.papers = try context.fetch(Paper.createFetchRequest())
            self.searchTableView.reloadData()
        }
        catch {
            print("Fetching failed")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.searchTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "ST1", "ST2", "PUT", "UT"]
        searchController.searchBar.delegate = self
        
        
        APIManager.sharedInstance.delegate = self
        APIManager.sharedInstance.getLastUpdate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if !launchedBefore {
        
            self.showLoading()
            
            // Call get all papers endpoint and populate db
            APIManager.sharedInstance.getAllPapers()
            
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        else {
            self.hideLoading()
            self.loadData()
            
        }
    }
}


// MARK: Table View datasource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive && self.searchController.searchBar.text != "" {
            return filteredPapers.count
        }
        return self.papers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "search-cell") as! SearchCell
        let paper: Paper
        if searchController.isActive && searchController.searchBar.text != "" {
            paper = self.filteredPapers[indexPath.row]
            print(paper)
        } else {
            paper = self.papers[indexPath.row]
        }
        cell.nameLabel.text = paper.name
        cell.examTypeLabel.text = paper.examTypeID?.stringValue ?? "Not available"
        return cell
    }
    
}

// MARK: Table View delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadButton = UITableViewRowAction(style: .normal, title: "Download") {
            action, index in
            
            let paper = self.papers[indexPath.row]
            let url = paper.fileURL
            
            // Call the download endpoint
            APIManager.sharedInstance.downloadPaper(url: url!)
            
            self.searchTableView.isEditing = false
        }
        
        downloadButton.backgroundColor = UIColor.lightGray
        
        return [downloadButton]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension SearchViewController: APIManagerDelegate {
    func didFinishTask() {
        self.loadData()
        self.hideLoading()
        
    }
    
    func didFinishDownload() {
        self.tabBarController?.tabBar.items?.last?.badgeValue = "1"
    }
}


