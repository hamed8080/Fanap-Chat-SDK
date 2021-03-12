//
//  NewAddContactRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/12/21.
//

import Foundation

public class NewAddContactRequest : BaseRequest {
    
    public var cellphoneNumber:    String?
    public var email:              String?
    public var firstName:          String?
    public var lastName:           String?
    public var ownerId:            Int?
    public var username:           String?

    
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
        super.init(uniqueId: uniqueId, typeCode: typeCode)
    }
    
    /// Add Contact with username
    public init(email:      String?,
                firstName:  String?,
                lastName:   String?,
                ownerId:    Int?,
                username:   String?,
                typeCode:   String?,
                uniqueId:   String?) {
        
        self.cellphoneNumber    = nil
        self.email              = email
        self.firstName          = firstName
        self.lastName           = lastName
        self.ownerId            = ownerId
        self.username           = username
        super.init(uniqueId: uniqueId, typeCode: typeCode)
    }
    
}
