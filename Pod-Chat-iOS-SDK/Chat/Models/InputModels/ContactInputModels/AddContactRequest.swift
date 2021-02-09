//
//  AddContactRequestModel.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 2/2/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class AddContactRequest :Encodable {
    
    public var cellphoneNumber    : String?
    public var email              : String?
    public var firstName          : String?
    public var lastName           : String?
    public var ownerId            : Int?
    public var username           : String?
    public var typeCode           : String
	public var uniqueId:           String = UUID().uuidString // uniqueId needed in request model sened to server
    
    public init(cellphoneNumber    : String? = nil,
                email              : String? = nil,
                firstName          : String? = nil,
                lastName           : String? = nil,
                ownerId            : Int?    = nil,
                typeCode           : String? = "default",
                uniqueId           : String? = nil) {
        
        self.cellphoneNumber    = cellphoneNumber
        self.email              = email
        self.firstName          = firstName
        self.lastName           = lastName
        self.ownerId            = ownerId
        self.username           = nil
        self.typeCode           = typeCode ?? "default"
        self.uniqueId           = uniqueId ?? UUID().uuidString
    }
}


@available(*, unavailable,message: "the class was removed use AddContactRequest instead")
open class AddContactRequestModel: AddContactRequest {
    
}

