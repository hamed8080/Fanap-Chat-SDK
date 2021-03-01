//
//  LeaveThreadRequest.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

open class LeaveThreadRequest : Encodable {
    
    public let threadId:        Int
    public let clearHistory:    Bool?
    
	@available(*,deprecated , message: "rmoved in future release use request method.")
    public let typeCode:        String?
	@available(*,deprecated , message: "rmoved in future release use request method.")
    public let uniqueId:        String
    
    public init(threadId:       Int,
                clearHistory:   Bool?,
                typeCode:       String? = nil,
                uniqueId:       String? = nil) {
        
        self.threadId       = threadId
        self.clearHistory   = clearHistory
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
    public func convertContentToJSON() -> JSON {
        var content: JSON = [:]
        if let clearHistory_ = clearHistory {
            content["clearHistory"] = JSON(clearHistory_)
        }
        return content
    }
    
    private enum CodingKeys : String , CodingKey {
        case clearHistory = "clearHistory"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(clearHistory, forKey: .clearHistory)
    }
    
}

@available(*,deprecated , message: "rmoved in future release use request method.")
open class LeaveThreadRequestModel: LeaveThreadRequest {
    
}

