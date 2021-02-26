//
//  PinUnpinMessageRequest.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 10/29/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import SwiftyJSON

open class PinUnpinMessageRequest: RequestModelDelegates  , Encodable {
    
    public let messageId:   Int
    public let notifyAll:   Bool
    
    @available(*,deprecated , message: "removed in future release.use request method")
    public let typeCode:    String?
    @available(*,deprecated , message: "removed in future release.use request method")
    public let uniqueId:    String
    
    public init(messageId:  Int,
                notifyAll:  Bool = false,
                typeCode:   String? = nil,
                uniqueId:   String? = nil) {
        
        self.messageId  = messageId
        self.notifyAll  = notifyAll
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
    public func convertContentToJSON() -> JSON {
        var content: JSON = [:]
        content["notifyAll"] = JSON(notifyAll)
        return content
    }
    
    public func convertContentToJSONArray() -> [JSON] {
        return []
    }
    private enum CodingKeys : String , CodingKey{
        case notifyAll = "notifyAll"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(notifyAll, forKey: .notifyAll)
    }
    
}


@available(*,deprecated , message: "removed in future release.use PinUnpinMessageRequest")
open class PinAndUnpinMessageRequestModel: PinUnpinMessageRequest {
    
}

