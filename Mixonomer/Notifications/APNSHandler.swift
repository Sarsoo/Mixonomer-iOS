//
//  APNSHandler.swift
//  Mixonomer
//
//  Created by Andy Pack on 27/11/2022.
//  Copyright © 2022 Sarsoo. All rights reserved.
//

import Foundation
import OSLog

class APNSHandler {
    
    static func pass_token_to_backend(onFailure: (() -> Void)? = nil) {
        // check if a token is waiting to be handed off
        if let token = StaticNotif.token {
            if !StaticNotif.hasDelivered {
                
                Logger.sys.info("passing off APNS network token")
                let api = UserApi.passAPNSToken(updates: token)
                RequestBuilder.buildRequest(apiRequest: api).responseJSON{ response in
                    
                    if NetworkHelper.check_network_response(response: response) {
                        Logger.net.debug("successfully handed off APNS token")
                        StaticNotif.hasDelivered = true
                    } else {
                        Logger.net.error("failed to hand off APNS token: \(response.response?.statusCode ?? 0)")
                        onFailure?()
                    }
                }
            }
        }
        else {
            Logger.sys.debug("no APNS token waiting, skipping network handoff")
        }
    }
}
