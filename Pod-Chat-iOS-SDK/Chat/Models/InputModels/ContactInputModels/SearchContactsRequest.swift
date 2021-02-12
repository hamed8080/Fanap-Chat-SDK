//
//  SearchContactsRequestModel.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class SearchContactsRequest {
    
    public let cellphoneNumber: String?
    public let contactId:       Int?
    public let count:           Int?
    public let email:           String?
    public let offset:          Int?
    public let order:           Ordering?
    public let query:           String?
    public let summery:         Bool?
    public let typeCode:        String?
    
    @available(*,deprecated , message: "remove from future release. use uniqueId in searchContacts method parameter")
    public let uniqueId:        String
    
    @available(*,deprecated , message: "remove from future release. use init without uniqueId")
    public init(cellphoneNumber:    String?,
                contactId:          Int?,
                count:              Int?,
                email:              String?,
                offset:             Int?,
                order:              Ordering?,
                query:              String?,
                summery:            Bool?,
                typeCode:           String?,
                uniqueId:           String?) {
        self.cellphoneNumber    = cellphoneNumber
        self.contactId          = contactId
        self.count              = count ?? 50
        self.email              = email
        self.offset             = offset ?? 0
        self.order              = order
        self.query              = query
        self.summery            = summery
        self.typeCode           = typeCode
        self.uniqueId           = uniqueId ?? UUID().uuidString
    }
    
    public init(cellphoneNumber:    String? = nil,
                contactId:          Int? = nil,
                count:              Int? = nil,
                email:              String? = nil,
                offset:             Int? = nil,
                order:              Ordering? = nil,
                query:              String? = nil,
                summery:            Bool? = nil,
                typeCode:           String? = nil) {
        
        self.cellphoneNumber    = cellphoneNumber
        self.contactId          = contactId
        self.count              = count ?? 50
        self.email              = email
        self.offset             = offset ?? 0
        self.order              = order
        self.query              = query
        self.summery            = summery
        self.typeCode           = typeCode
        //removed in future release
        self.uniqueId           = UUID().uuidString
    }
    
}


@available(*,unavailable , message:"use SearchContactsRequest class")
open class SearchContactsRequestModel{}

