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
                        paper.examTypeID = item.1.dictionaryValue["exam)type_id"]?.numberValue
                        delegate.saveContext()
                    }
                }
                self.delegate?.didFinishTask()
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
        Alamofire.request(Router.getLastUpdate()).responseString{
            response in
            if let recievedString = response.result.value {
                print(recievedString)
            }
        }
        
    }
}
