//
//  Router.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 30/12/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://bp.silive.in/"
    
    case getAll()
    case getVersion()
    case getLastUpdate()
    case getPaper(String)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getAll():
                return .get
            case .getVersion():
                return .get
            case .getLastUpdate():
                return .get
            case .getPaper(_):
                return .get
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .getAll():
                relativePath = "api/list"
            case .getVersion():
                relativePath = "api/get_verison_"
            case .getLastUpdate():
                relativePath = "api/last_update_"
            case .getPaper(let relativeURL):
                relativePath = "PaperFileUpload/" + relativeURL
            }
            
            
            
            var url = URL(string: Router.baseURLString)
            url?.appendPathComponent(relativePath)
            return url!
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
//        urlRequest.timeoutInterval = 5
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: nil)
        
    }
}
