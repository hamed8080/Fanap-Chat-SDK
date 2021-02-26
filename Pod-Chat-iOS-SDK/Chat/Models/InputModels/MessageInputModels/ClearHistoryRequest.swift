//
//  ClearHistoryRequestModel.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 2/23/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import SwiftyJSON

@available(*,deprecated , message: "removed in future release.use request method and threadId in parameter.")
open class ClearHistoryRequest: RequestModelDelegates {
    
    public let threadId:    Int
    
    public let typeCode:    String?
    public let uniqueId:    String
    
    public init(threadId:   Int,
                typeCode:   String?,
                uniqueId:   String?) {
        
        self.threadId   = threadId
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
    public func convertContentToJSON() -> JSON {
        var content: JSON = [:]
        content["threadId"] = JSON(self.threadId)
        
        return content
    }
    
    public func convertContentToJSONArray() -> [JSON] {
        return []
    }
    
}


@available(*,deprecated , message: "removed in future release.use ClearHistoryRequest")
open class ClearHistoryRequestModel: ClearHistoryRequest {
    
}
