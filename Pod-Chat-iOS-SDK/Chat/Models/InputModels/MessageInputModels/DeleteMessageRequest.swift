//
//  DeleteMessageRequestModel.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

open class DeleteMessageRequest: RequestModelDelegates , Encodable {
    
    public let deleteForAll:    Bool
    public let messageId:       Int
    
    @available(*,deprecated , message: "removed in future release.use request method")
    public let typeCode:    String?
    @available(*,deprecated , message: "removed in future release.use request method")
    public let uniqueId:    String
    @available(*,deprecated , message: "removed in future release.use messageId")
    public let subjectId: Int
    
    public init(deleteForAll:   Bool? = false,
                messageId:      Int,
                typeCode:       String? = nil,
                uniqueId:       String? = nil) {
        
        self.deleteForAll   = deleteForAll ?? false
        self.messageId      = messageId
        
        self.subjectId      = messageId
        
        self.typeCode       = typeCode
        self.uniqueId       = uniqueId ?? UUID().uuidString
    }
    
    @available(*,deprecated , message: "removed in future release.use init with messageId instead")
    public init(deleteForAll:   Bool? = false,
                subjectId:      Int,
                typeCode:       String?,
                uniqueId:       String?) {
        
        self.deleteForAll   = deleteForAll ?? false
        self.messageId      = subjectId
        
        self.subjectId      = subjectId
        
        self.typeCode       = typeCode
        self.uniqueId       = uniqueId ?? UUID().uuidString
    }
    
    public func convertContentToJSON() -> JSON {
        var content: JSON = []
        content["deleteForAll"] = JSON("\(deleteForAll)")
        return content
    }
    
    public func convertContentToJSONArray() -> [JSON] {
        return []
    }
    
    private enum CodingKeys : String , CodingKey{
        case deleteForAll = "deleteForAll"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deleteForAll, forKey: .deleteForAll)
    }
    
}


@available(*,deprecated , message: "removed in future release.use DeleteMessageRequest")
open class DeleteMessageRequestModel: DeleteMessageRequest {
    
}
