//
//  RemoveContactsRequestModel.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class RemoveContactsRequest : Encodable{
    
    public let contactId:   Int
    
    public let typeCode:    String?
    
    @available(*,deprecated , message: "removed from future release. use uniqueId inside parameter in deleteContact method")
    public var uniqueId:    String = UUID().uuidString
    
    
    @available(*,deprecated , message: "removed from future release. use init without uniqueId")
    public init(contactId:  Int,
                typeCode:   String?,
                uniqueId:   String?) {
        self.contactId  = contactId
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
    public init(contactId:  Int,
                typeCode:   String = "default") {
        
        self.contactId  = contactId
        self.typeCode   = typeCode
    }
    
    private enum CodingKeys:String ,CodingKey{
        case contactId = "id"
        case typeCode = "typeCode"
    }
    
    @available(*,deprecated , message: "removed in future release after remove uniqueId from this class")
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(contactId, forKey: .contactId)
        try? container.encode(typeCode, forKey: .typeCode)
    }
    
}

/// MARK: -  this class will be deprecate (use this class instead: 'RemoveContactsRequest')
open class RemoveContactsRequestModel: RemoveContactsRequest {
    
}

