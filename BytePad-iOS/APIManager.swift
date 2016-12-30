//
//  BytePadAPIManager.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 30/12/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit
import Alamofire

class APIManager {
    static let sharedInstance = APIManager()
    
    func getAllPapers() {
        Alamofire.request(Router.getAll()).responseString {
            response in
            if let recievedString = response.result.value {
                print(recievedString)
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
}
