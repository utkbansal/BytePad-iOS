//
//  BytePadAPIManager.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 30/12/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol APIManagerDelegate: class {
    func didFinishDownloadAll(success: Bool)
    func didFinishDownload(success: Bool)
    func didGetUpdate(success: Bool)
}


class APIManager {
    static let sharedInstance = APIManager()
    weak var delegate: APIManagerDelegate?
    
    func getAllPapers() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(Router.getAll()).responseJSON {
            response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if response.result.isSuccess == true {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let context = delegate.persistentContainer.viewContext
                if let data = response.result.value {
                    let json = JSON(data)
                    for item in json {
                        let paper = Paper(context: context)
                        
                        paper.fileURL =  item.1.dictionaryValue["file_url"]?.stringValue
                        paper.semester = item.1.dictionaryValue["semester"]?.numberValue
                        paper.examTypeID = item.1.dictionaryValue["exam_type_id"]?.numberValue
                        paper.name = paper.fileURL?.components(separatedBy: "/").last?.components(separatedBy: ".").dropLast().joined()
                        delegate.saveContext()
                    }
                }
                self.delegate?.didFinishDownloadAll(success: true)
            } else {
                
                self.delegate?.didFinishDownloadAll(success: false)
            }
        }
    }
    
    func getVersion() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(Router.getVersion()).responseString {
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let recievedString = response.result.value {
                print(recievedString)
            }
        }
    }
    
    func getLastUpdate() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(Router.getLastUpdate()).responseJSON{
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.result.value {
                let json = JSON(data)
                if let dateString: String = json.stringValue.components(separatedBy: ".").first {
                    let dateFormatter: DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    if let date = dateFormatter.date(from: dateString) {
                        UserDefaults.standard.set(date, forKey: "lastSeverUpdate")
                        self.delegate?.didGetUpdate(success: true)
                    }
                }
            }
            else {
                self.delegate?.didGetUpdate(success: false)
                
            }
        }
    }
    
    func downloadPaper(url: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
        
        Alamofire.download(Router.getPaper(url), to: destination).response {
            response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if response.error == nil{
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                do {
                    let download = Download(context: context)
                    download.fileName = url.components(separatedBy: "/").last!
                    try context.save()
                } catch {
                    print("Download not saved")
                }
                
                self.delegate?.didFinishDownload(success: true)
            }
            else{
                print("Failed with error: \(response.error)")
                self.delegate?.didFinishDownload(success: false)
            }
        }
        
        
        
    }
    
}
