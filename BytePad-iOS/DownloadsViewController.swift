//
//  DownloadsViewController.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 13/11/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit

class DownloadsViewController: UIViewController {

    @IBOutlet weak var downloadsTableView: UITableView!
    
    var downloadedPapers: [(name: String, url: String)] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            print(directoryContents)
            
            for  file in directoryContents {
                print(file.lastPathComponent)
                print(file.absoluteURL)
                print(file.baseURL)
                print((file as NSURL).filePathURL)
                
                // Save the data in the list as a tuple
                self.downloadedPapers.append((file.lastPathComponent, file.absoluteString))
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.downloadsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

}

extension DownloadsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.downloadedPapers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.downloadsTableView.dequeueReusableCell(withIdentifier: "downloads-cell")
        cell?.textLabel?.text = self.downloadedPapers[indexPath.row].name
        
        return cell!
        
    }
}
