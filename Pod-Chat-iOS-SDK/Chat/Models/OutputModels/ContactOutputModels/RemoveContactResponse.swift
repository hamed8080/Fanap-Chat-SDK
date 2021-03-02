//
//  RemoveContactResponse.swift
//  Chat
//
//  Created by Mahyar Zhiani on 7/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

@available(*,deprecated , message:"removed in future release.use NewRemoveContactResponse")
open class RemoveContactModel: ResponseModel, ResponseModelDelegates {
	
	public var result:  Bool
	
	@available(*,deprecated , message:"removed in future release")
	public init(messageContent: JSON) {
		
		self.result = messageContent["result"].boolValue
		super.init(hasError:        messageContent["hasError"].boolValue,
				   errorMessage:    messageContent["message"].string ?? "",
				   errorCode:       messageContent["errorCode"].int ?? 0)
	}
	
	@available(*,deprecated , message:"removed in future release")
	public init(hasError:       Bool,
				errorMessage:   String?,
				errorCode:      Int?,
				result:         Bool) {
		
		self.result = result
		super.init(hasError:        hasError,
				   errorMessage:    errorMessage ?? "",
				   errorCode:       errorCode ?? 0)
	}
    
   public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
	@available(*,deprecated , message:"removed in future release")
	public func returnDataAsJSON() -> JSON {
		let finalResult: JSON = ["result":          result,
								 "hasError":        hasError,
								 "errorMessage":    errorMessage,
								 "errorCode":       errorCode]
		
		return finalResult
	}

}

@available(*,deprecated , message:"removed in future release")
open class RemoveContactResponse: RemoveContactModel {
	
}


