//
//  BytePadAPIManager.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 30/12/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit
import Alamofire

protocol APIManagerDelegate: class {
    func didFinishTask()
}


class APIManager {
    static let sharedInstance = APIManager()
    weak var delegate: APIManagerDelegate?
    
    func getAllPapers() {
        Alamofire.request(Router.getAll()).responseString {
            response in
            if let recievedString = response.result.value {
                print(recievedString)
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
