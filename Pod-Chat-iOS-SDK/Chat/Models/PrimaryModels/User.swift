//
//  User.swift
//  Chat
//
//  Created by Mahyar Zhiani on 7/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON


/*
 * + User               User:
 *    - cellphoneNumber:    String?
 *    - email:              String?
 *    - id:                 Int?
 *    - image:              String?
 *    - lastSeen:           Int?
 *    - name:               String?
 *    - receiveEnable:      Bool?
 *    - sendEnable:         Bool?
 */

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
    
	@available(*, deprecated, message:"removed from future release.")
    public init(messageContent: JSON) {
        
        self.cellphoneNumber    = messageContent["cellphoneNumber"].string
        self.coreUserId         = messageContent["coreUserId"].int
        self.contactSynced      = messageContent["contactSynced"].bool ?? false
        self.email              = messageContent["email"].string
        self.id                 = messageContent["id"].int
        self.image              = messageContent["image"].string
        self.lastSeen           = messageContent["lastSeen"].int
        self.name               = messageContent["name"].string
        self.receiveEnable      = messageContent["receiveEnable"].bool
        self.sendEnable         = messageContent["sendEnable"].bool
        self.username           = messageContent["username"].string
        if (messageContent["chatProfileVO"] != JSON.null) {
            self.chatProfileVO  = Profile(messageContent: messageContent["chatProfileVO"])
        }
    }
    
    public init(cellphoneNumber:    String?,
                contactSynced:      Bool?,
                coreUserId:         Int?,
                email:              String?,
                id:                 Int?,
                image:              String?,
                lastSeen:           Int?,
                name:               String?,
                receiveEnable:      Bool?,
                sendEnable:         Bool?,
                username:           String?,
                chatProfileVO:      Profile?) {
        
        self.cellphoneNumber    = cellphoneNumber
        self.contactSynced      = contactSynced ?? false
        self.coreUserId         = coreUserId
        self.email              = email
        self.id                 = id
        self.image              = image
        self.lastSeen           = lastSeen
        self.name               = name
        self.receiveEnable      = receiveEnable
        self.sendEnable         = sendEnable
        self.username           = username
        self.chatProfileVO      = chatProfileVO
    }
    
	@available(*, deprecated, message:"removed from future release.")
    public init(withUserObject: User) {
        
        self.cellphoneNumber    = withUserObject.cellphoneNumber
        self.contactSynced      = withUserObject.contactSynced
        self.coreUserId         = withUserObject.coreUserId
        self.email              = withUserObject.email
        self.id                 = withUserObject.id
        self.image              = withUserObject.image
        self.lastSeen           = withUserObject.lastSeen
        self.name               = withUserObject.name
        self.receiveEnable      = withUserObject.receiveEnable
        self.sendEnable         = withUserObject.sendEnable
        self.username           = withUserObject.username
        self.chatProfileVO      = withUserObject.chatProfileVO
    }
    
	@available(*, deprecated, message:"removed from future release.")
    public func formatToJSON() -> JSON {
        let result: JSON = ["cellphoneNumber":  cellphoneNumber ?? NSNull(),
                            "contactSynced":    contactSynced,
                            "coreUserId":       coreUserId ?? NSNull(),
                            "email":            email ?? NSNull(),
                            "id":               id ?? NSNull(),
                            "image":            image ?? NSNull(),
                            "lastSeen":         lastSeen ?? NSNull(),
                            "name":             name ?? NSNull(),
                            "receiveEnable":    receiveEnable ?? NSNull(),
                            "sendEnable":       sendEnable ?? NSNull(),
                            "username":         username ?? NSNull(),
                            "chatProfileVO":    chatProfileVO?.formatToJSON() ?? NSNull()]
        return result
    }
    
}
