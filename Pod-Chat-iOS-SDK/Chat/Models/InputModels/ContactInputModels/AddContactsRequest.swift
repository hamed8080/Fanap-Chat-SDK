//
//  AddContactsRequestModel.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation


open class AddContactsRequest :Encodable{
    
    public let cellphoneNumbers:    [String]
    public let emails:              [String]
    public let firstNames:          [String]
    public let lastNames:           [String]
    public let usernames:           [String]
    public let typeCode:            String?
    public let uniqueIds:           [String]
    
    // Memberwise initializer
    public init(cellphoneNumbers:    [String]? = nil,
                emails:             [String],
                firstNames:         [String],
                lastNames:          [String],
				userNames:			[String]? = nil,
                typeCode:           String? = nil,
                uniqueIds:          [String]) {
        
        self.cellphoneNumbers    = cellphoneNumbers ?? []
        self.emails             = emails
        self.firstNames         = firstNames
        self.lastNames          = lastNames
        self.usernames          = userNames ?? []
        self.typeCode           = typeCode
        self.uniqueIds          = uniqueIds
    }
}

@available(*,unavailable , message: "this class removed use AddContactsRequest")
open class AddContactsRequestModel: AddContactsRequest {
}


