//
//  ContactResponse.swift
//  Chat
//
//  Created by Mahyar Zhiani on 7/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON


open class ContactModel: ResponseModel, ResponseModelDelegates {
    
    public var contentCount:       Int = 0
    public var contacts:           [Contact] = []
    
	@available(*,deprecated , message:"removed in future release")
    public init(messageContent: JSON) {
        
        if let result = messageContent["result"].array {
            for item in result {
                let tempContact = Contact(messageContent: item)
                self.contacts.append(tempContact)
            }
        }
        self.contentCount = messageContent["count"].intValue
        super.init(hasError:        messageContent["hasError"].bool ?? false,
                   errorMessage:    messageContent["message"].string ?? "",
                   errorCode:       messageContent["errorCode"].int ?? 0)
    }
    
	@available(*,deprecated , message:"removed in future release")
    public init(contentCount:   Int,
                messageContent: [Contact]?,
                hasError:       Bool,
                errorMessage:   String?,
                errorCode:      Int?) {
        
        if let result = messageContent {
            for item in result {
                self.contacts.append(item)
            }
        }
        self.contentCount = contentCount
        super.init(hasError:        hasError,
                   errorMessage:    errorMessage ?? "",
                   errorCode:       errorCode ?? 0)
    }
    
	@available(*,deprecated , message:"removed in future release")
    public func returnDataAsJSON() -> JSON {
        var contactArr = [JSON]()
        for item in contacts {
            contactArr.append(item.formatToJSON())
        }
        let result: JSON = ["contacts":     contactArr,
                            "contentCount": contentCount]
        
        let finalResult: JSON = ["result":      result,
                                 "hasError":    hasError,
                                 "errorMessage": errorMessage,
                                 "errorCode":   errorCode]
        
        return finalResult
    }
	
	private enum CodingKeys:String , CodingKey{
		case contacts     = "result"
		case contentCount = "count"
		case hasError     = "hasError"
		case message      = "message"
		case errorCode    = "errorCode"
	}
	
	public required init(from decoder: Decoder) throws {
		let container     =  try  decoder.container(keyedBy: CodingKeys.self)
		contacts          = try container.decodeIfPresent([Contact].self, forKey: .contacts) ?? []
		contentCount      = try container.decodeIfPresent(Int.self, forKey: .contentCount) ?? 0
		let errorCode     = try container.decodeIfPresent(Int.self, forKey: .errorCode) ?? 0
		let hasError      = try container.decodeIfPresent(Bool.self, forKey: .hasError) ?? false
		let message       = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
		super.init(hasError: hasError,
				   errorMessage: message,
				   errorCode: errorCode)
	}
}


open class ContactResponse: ContactModel {
    
}
