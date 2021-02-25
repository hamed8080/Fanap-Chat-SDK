//
//  User.swift
//  Chat
//
//  Created by Mahyar Zhiani on 7/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class User : Codable {
    
    
    public var cellphoneNumber: String?
    public var contactSynced:   Bool
    public var coreUserId:      Int?
    public var email:           String?
    public var id:              Int?
    public var image:           String?
    public var lastSeen:        Int?
    public var name:            String?
    public var receiveEnable:   Bool?
    public var sendEnable:      Bool?
    public var username:        String?
    public var chatProfileVO:   Profile?
    
    public init(cellphoneNumber:    String? = nil ,
                contactSynced:      Bool? = nil,
                coreUserId:         Int? = nil,
                email:              String? = nil,
                id:                 Int? = nil,
                image:              String?  = nil,
                lastSeen:           Int?  = nil,
                name:               String?  = nil,
                receiveEnable:      Bool?  = nil,
                sendEnable:         Bool?  = nil,
                username:           String?  = nil,
                chatProfileVO:      Profile?  = nil) {
        
        self.cellphoneNumber = cellphoneNumber
        self.contactSynced   = contactSynced ?? false
        self.coreUserId      = coreUserId
        self.email           = email
        self.id              = id
        self.image           = image
        self.lastSeen        = lastSeen
        self.name            = name
        self.receiveEnable   = receiveEnable
        self.sendEnable      = sendEnable
        self.username        = username
        self.chatProfileVO   = chatProfileVO
    }
}
