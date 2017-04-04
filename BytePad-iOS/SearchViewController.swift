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
    @IBOutlet weak var retryButton: UIButton!
    
    @IBAction func retryButtonTapped(_ sender: Any) {
    }
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
        self.loadingTextLabel.text = "Moving satalites into position..."
        self.searchTableView.isHidden = true
        self.retryButton.isHidden = true
    }
    
    func showTable() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.loadingTextLabel.isHidden = true
        self.searchTableView.isHidden = false
        self.retryButton.isHidden = true
    }
    
    func showRetry() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.searchTableView.isHidden = true
        self.loadingTextLabel.text = "Some error occured!"
        self.loadingTextLabel.isHidden = false
        self.retryButton.isHidden = false
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
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if !launchedBefore {
            
            self.showLoading()
            
            // Call get all papers endpoint and populate db
            APIManager.sharedInstance.getAllPapers()
            
        }
        else {
            self.showTable()
            self.loadData()
            
            APIManager.sharedInstance.getLastUpdate()
            
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
        cell.examTypeLabel.text = paper.exam ?? "Not available"
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
    
    func didFinishDownloadAll(success: Bool) {
        if success {
            // First launch is considered only when the data is successfully saved for the first time
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            // Set timestamp for last update
            UserDefaults.standard.set(Date(), forKey: "lastLocalUpdate")
            self.loadData()
            self.showTable()
        }
        else {
            self.showRetry()
        }
    }
    
    func didFinishDownload(success: Bool) {
        if success {
            self.tabBarController?.tabBar.items?.last?.badgeValue = "new"
        }
        else {
            let alert = UIAlertController(title: "Download Failed!", message: "The download has failed due to some unexpected reason. Please check your network.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func didGetUpdate(success: Bool) {
        if success {
            let localUpdate = UserDefaults.standard.object(forKey: "lastLocalUpdate") as! Date
            let serverUpdate = UserDefaults.standard.object(forKey: "lastSeverUpdate") as! Date
            print(serverUpdate)
            print(localUpdate)
            if serverUpdate > localUpdate {
                let alert = UIAlertController(title: "Update", message: "New papers are now available. Do you want to update?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}


