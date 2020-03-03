//
//  TagApi.swift
//  Music Tools
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum TagApi {
    case getTags
    case runTag(tag_id: String)
    case updateTag(tag_id: String, updates: JSON)
    case deleteTag(tag_id: String)
    case newTag(tag_id: String)
    case getTag(tag_id: String)
}

extension TagApi: ApiRequest {
    var domain: String {
        return ApiRequestDefaults.domain
    }
    
    var path: String {
        switch self {
        case .getTags:
            return "api/tag"
        case .runTag(let tag_id):
            return "api/tag/\(tag_id)/update"
        case .updateTag(let tag_id):
            return "api/tag/\(tag_id)"
        case .deleteTag(let tag_id):
            return "api/tag/\(tag_id)"
        case .newTag(let tag_id):
            return "api/tag/\(tag_id)"
        case .getTag(let tag_id):
            return "api/tag/\(tag_id)"
        }
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        switch self {
        case .getTags:
            return .get
        case .runTag:
            return .get
        case .updateTag:
            return .put
        case .deleteTag:
            return .delete
        case .newTag:
            return .post
        case .getTag:
            return .get
        }
    }
    
    var parameters: JSON? {
        switch self {
        case .getTags:
            return nil
        case .runTag:
            return nil
        case .updateTag(let _, let updates):
            return updates
        case .deleteTag:
            return nil
        case .newTag:
            return nil
        case .getTag:
            return nil
        }
    }
    
    var parameterType: ParameterEncoder? {
        switch self {
        case .getTags:
            return nil
        case .runTag:
            return nil
        case .updateTag:
            return JSONParameterEncoder.default
        case .deleteTag:
            return nil
        case .newTag:
            return nil
        case .getTag:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var authMethod: AuthMethod? {
        return ApiRequestDefaults.authMethod
    }
    
    
}

