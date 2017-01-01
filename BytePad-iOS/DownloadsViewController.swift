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
    
    var downloadedPapers: [Download] = []
    let preview = QLPreviewController()
    
    // MARK: QLPreview
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return self.downloadedPapers.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(self.downloadedPapers[index].fileName)
        return fileURL as QLPreviewItem
    }
    
    func loadData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            self.downloadedPapers = try context.fetch(Download.createFetchRequest())
            self.downloadsTableView.reloadData()
        }
        catch {
            print("Fetching failed")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        
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
        let cell = self.downloadsTableView.dequeueReusableCell(withIdentifier: "downloads-cell") as! DownloadCell
        cell.paperNameLabel.text = self.downloadedPapers[indexPath.row].fileName
        cell.extraInfoLabel.text = "PDF Document"
        
        return cell
        
    }
}

extension DownloadsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.preview.currentPreviewItemIndex = (indexPath as NSIndexPath).row
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(preview, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
//            let paper = self.downloadedPapers[indexPath.row]
//            do {
//                try FileManager.default.removeItem(at: URL(string: paper.url)!)
//                self.downloadedPapers.remove(at: indexPath.row)
//                self.downloadsTableView.reloadData()
//            }
//            catch {
//                print("deletion error")
//            }
//            
//            self.downloadsTableView.isEditing = false
        }
    }
    
}
