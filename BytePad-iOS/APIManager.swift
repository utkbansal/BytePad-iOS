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
    func didFinishTask()
    func didFinishDownload()
}


class APIManager {
    static let sharedInstance = APIManager()
    weak var delegate: APIManagerDelegate?
    
    func getAllPapers() {
        Alamofire.request(Router.getAll()).responseJSON {
            response in
            
            if response.result.isSuccess == true {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let context = delegate.persistentContainer.viewContext
                if let data = response.result.value {
                    let json = JSON(data)
                    for item in json {
                        let paper = Paper(context: context)
                        print(item)
                        
                        paper.fileURL =  item.1.dictionaryValue["file_url"]?.stringValue
                        paper.semester = item.1.dictionaryValue["semester"]?.numberValue
                        paper.examTypeID = item.1.dictionaryValue["exam_type_id"]?.numberValue
                        paper.name = paper.fileURL?.components(separatedBy: "/").last?.components(separatedBy: ".").dropLast().joined()
                        delegate.saveContext()
                    }
                }
                self.delegate?.didFinishTask()
            } else {
                
                print("kuch to hua hai")
            }
        }
    }
    
    func getVersion() {
        Alamofire.request(Router.getVersion()).responseString {
            response in
            if let recievedString = response.result.value {
                print(recievedString)
            }
        }
    }
    
    func getLastUpdate() {
        Alamofire.request(Router.getLastUpdate()).responseJSON{
            response in
            if let data = response.result.value {
                let json = JSON(data)
                if let dateString: String = json.stringValue.components(separatedBy: ".").first {
                    let dateFormatter: DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    if let date = dateFormatter.date(from: dateString) {
                        print(date)
                    }
                    
                }
            }
            else {
                print("error")
                
            }
        }
    }
    
    func downloadPaper(url: String) {
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
//        let fileURL = URL(string: url.replacingOccurrences(of: " ", with: "%20"))
        let fileURL = URL(string: "http://placehold.it/600/f66b97")
        
        Alamofire.download(fileURL!, to: destination).response {
            response in
            if response.error == nil{
                print("Downloaded file successfully")
            }
            else{
                print("Failed with error: \(response.error)")
            }
            self.delegate?.didFinishDownload()
        }
        
        
        
    }
    
}
