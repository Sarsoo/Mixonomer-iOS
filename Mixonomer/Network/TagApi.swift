//
//  TagApi.swift
//  Mixonomer
//
//  Created by Andy Pack on 20/02/2020.
//  Copyright © 2020 Sarsoo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import OSLog

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
        case .updateTag(let tag_id, _):
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
        case .updateTag(_, let updates):
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
    
    static func fromJSON(tag: JSON) -> Tag? {
        
        let _json = tag.rawString()?.data(using: .utf8)
        
        if let data = _json {
            let decoder = JSONDecoder()
            do {
                let _tag = try decoder.decode(Tag.self, from: data)
                return _tag
            } catch {
                Logger.parse.error("error parsing tag from json: \(error)")
            }
        }
        return nil
    }
    
    // TODO this loop could be condensed
    static func fromJSON(tag: [JSON]) -> [Tag] {
        var _tags: [Tag] = []
        for dict in tag {
            let _iter = self.fromJSON(tag: dict)
            if let returned = _iter {
                _tags.append(returned)
            }
        }
        return _tags
    }
}

