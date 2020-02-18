//
//  Network.swift
//  Music Tools
//
//  Created by Andy Pack on 18/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation
import Alamofire

class MusicToolsNetwork {
    
    var baseBath: String = "https://music.sarsoo.xyz/"
    
    public func request(path: String,
                 method: Alamofire.HTTPMethod,
                 parameters: [String:String]? ,
                 encoder: Alamofire.ParameterEncoder?,
                 headers: Alamofire.HTTPHeaders? ) {
        
        guard let uwParameters = parameters else {
           AF.request(baseBath + path,
                       method: method,
                       headers: headers ).validate().response { response in
                debugPrint(response)
            }
            return
        }
        
        AF.request(baseBath + path,
                   method: method,
                   parameters: uwParameters,
                   headers: headers ).response { response in
            debugPrint(response)
        }
        
    }
}

class BasicAuthNetwork: MusicToolsNetwork {
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func getHeader() -> String {
        return "\(username):\(password)".toBase64()
    }
    
    public func authedRequest(path: String,
                       method: Alamofire.HTTPMethod,
                       parameters: [String:String]?,
                       encoder: Alamofire.ParameterEncoder?,
                       headers: Alamofire.HTTPHeaders? ) {
        
        let encoded = "\(username):\(password)".toBase64()
        
        var txHeaders = headers
        
        if headers == nil {
            txHeaders = Alamofire.HTTPHeaders()
        }
        txHeaders?.add(name: "Authorization", value: "Basic \(encoded)")
        
        request(path: path, method: method, parameters: parameters, encoder: encoder, headers: txHeaders)
        
    }
}

extension String {
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
}
