//
//  NetworkHelper.swift
//  Mixonomer
//
//  Created by Andy Pack on 27/11/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import Foundation
import OSLog
import Alamofire

class NetworkHelper {
    
    static func check_network_response(response: AFDataResponse<Any>, onTokenFail: (() -> Void)? = nil) -> Bool {
        
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 401: // token has expired
                Logger.sys.info("token expired, logging user out")
                onTokenFail?()
                return false
            case 400..<500:
                Logger.net.error("client fault \(statusCode)")
                return false
            case 500..<600:
                Logger.net.warning("server fault \(statusCode)")
                return false
            case _: // 200 -> Success
                return true
            }
        }
        
        Logger.net.error("failed to access network status code to validate")
        
        return false
    }
}
