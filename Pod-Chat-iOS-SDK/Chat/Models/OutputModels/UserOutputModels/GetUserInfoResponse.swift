//
//  GetUserInfoResponse.swift
//  Chat
//
//  Created by Mahyar Zhiani on 7/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

open class UserInfoModel: ResponseModel, ResponseModelDelegates {
    
    public let user:    User
    
    public init(messageContent: JSON,
                hasError:       Bool,
                errorMessage:   String,
                errorCode:      Int) {
        
		let data = try! messageContent.rawData()
		let user = try! JSONDecoder().decode(User.self, from: data)
		self.user = user
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
    }
    
    public init(userObject:     User,
                hasError:       Bool,
                errorMessage:   String,
                errorCode:      Int) {
        
        self.user   = userObject
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
    }
	
	
	public required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
    public func returnDataAsJSON() -> JSON {
		
        let result: JSON = ["user": JSON(user)]
        
        let resultAsJSON: JSON = ["result":         result,
                                  "hasError":       hasError,
                                  "errorMessage":   errorMessage,
                                  "errorCode":      errorCode]
        
        return resultAsJSON
    }
    
}


open class GetUserInfoResponse: UserInfoModel {
    
}


