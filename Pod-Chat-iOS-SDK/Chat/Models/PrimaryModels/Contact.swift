//
//  Contact.swift
//  Chat
//
//  Created by Mahyar Zhiani on 7/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class Contact :Codable {
	
    /*
     *  + ContactVO          Contact:
     *      - blocked           Bool?
     *      - cellphoneNumber   String?
     *      - email             String?
     *      - firstName         String?
     *      - hasUser           Bool?
     *      - id                Int?
     *      - image             String?
     *      - lastName          String?
     *      - linkedUser        LinkedUser?
     *      - notSeenDuration   Int?
     *      - timeStamp         UInt?
     *      - uniqueId          Bool?
     *      - userId            Int?
     */
    
	public var blocked				     : Bool?
	public var cellphoneNumber		  	 : String?
	public var email				     : String?
	public var firstName				 : String?
	public var hasUser				     : Bool   = false
	public var id				         : Int?
	public var image				     : String?
	public var lastName				 : String?
	public var linkedUser				 : LinkedUser?
	public var notSeenDuration			 : Int?
	public var timeStamp				 : UInt?
	public var userId				     : Int?
	
	
	private enum CodingKeys:String,CodingKey{
		case blocked         	= "blocked"
		case cellphoneNumber 	= "cellphoneNumber"
		case email           	= "email"
		case firstName       	= "firstName"
		case lastName        	= "lastName"
		case hasUser         	= "hasUser"
		case id              = "id"
		case image           	= "profileImage"
		case linkedUser      	= "linkedUser"
		case notSeenDuration  	= "notSeenDuration"
		case timeStamp        = "timeStamp"
		case userId          	= "userId"
	}
	
	public required init(from decoder: Decoder) throws {
		guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {return}
		blocked 			= try container.decodeIfPresent(Bool.self, forKey : .blocked)
		cellphoneNumber 	= try container.decodeIfPresent(String.self, forKey: .cellphoneNumber)
		email 			= try container.decodeIfPresent(String.self, forKey: .email)
		firstName 		= try container.decodeIfPresent(String.self, forKey: .firstName)
		id 				= try container.decodeIfPresent(Int.self, forKey: .id)
		image 			= try container.decodeIfPresent(String.self, forKey: .image)
		lastName 			= try container.decodeIfPresent(String.self, forKey: .lastName)
		notSeenDuration 	= try container.decodeIfPresent(Int.self, forKey: .notSeenDuration)
		timeStamp 		= try container.decodeIfPresent(UInt.self, forKey: .timeStamp)
		userId 			= try container.decodeIfPresent(Int.self, forKey: .userId)
		hasUser 			= try container.decodeIfPresent(Bool.self, forKey: .hasUser) ?? false
		linkedUser 		= try container.decodeIfPresent(LinkedUser.self, forKey: .linkedUser)
		if linkedUser != nil {
			hasUser 		= true
		}
	}
	
//	Memberwise initializer
    public init(blocked:            Bool? = nil,
                cellphoneNumber:    String? = nil,
                email:              String? = nil,
                firstName:          String? = nil,
                hasUser:            Bool = false,
                id:                 Int? = nil,
                image:              String? = nil,
                lastName:           String? = nil,
                linkedUser:         LinkedUser? = nil,
                notSeenDuration:    Int? = nil,
                timeStamp:          UInt? = nil,
                userId:             Int? = nil) {

        self.blocked 				= blocked
        self.cellphoneNumber    	= cellphoneNumber
        self.email              	= email
        self.firstName          	= firstName
        self.hasUser            	= hasUser
        self.id                 	= id
        self.image              	= image
        self.lastName           	= lastName
        self.linkedUser         	= linkedUser
        self.notSeenDuration    	= notSeenDuration
        self.timeStamp          	= timeStamp
        self.userId             	= userId

    }
    
	@available(*, deprecated , message: "removed in future release use default constructor")
    public init(theContact: Contact) {

        self.blocked            = theContact.blocked
        self.cellphoneNumber    = theContact.cellphoneNumber
        self.email              = theContact.email
        self.firstName          = theContact.firstName
        self.hasUser            = theContact.hasUser
        self.id                 = theContact.id
        self.image              = theContact.image
        self.lastName           = theContact.lastName
        self.linkedUser         = theContact.linkedUser
        self.notSeenDuration    = theContact.notSeenDuration
        self.timeStamp          = theContact.timeStamp
        self.userId             = theContact.userId
    }
}
