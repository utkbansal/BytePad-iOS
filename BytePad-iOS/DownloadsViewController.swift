//
//  DownloadsViewController.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 13/11/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit
import QuickLook

class DownloadsViewController: UIViewController, QLPreviewControllerDataSource {

    @IBOutlet weak var downloadsTableView: UITableView!
    
    var downloadedPapers: [(name: String, url: String)] = []
    let preview = QLPreviewController()
    
    // MARK: QLPreview
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url:URL = URL(string: self.downloadedPapers[index].url)!
        return url as QLPreviewItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            print(directoryContents)
            
            for  file in directoryContents {
                
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
        self.downloadsTableView.delegate = self
        self.preview.dataSource = self
        self.preview.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

}

extension DownloadsViewController: QLPreviewControllerDelegate {
    
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        self.tabBarController?.tabBar.isHidden = false
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

extension DownloadsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(self.downloadedPapers[(indexPath as NSIndexPath).row].url)
        self.preview.currentPreviewItemIndex = (indexPath as NSIndexPath).row
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(preview, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {

        }
    }
}
