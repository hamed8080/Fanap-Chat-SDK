//
//  PinUnpinThreadResponse.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 10/7/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

open class PinUnpinThreadModel: ResponseModel, ResponseModelDelegates {
    
    public let threadId:    Int
    
    public init(threadId:       Int,
                hasError:       Bool,
                errorMessage:   String,
                errorCode:      Int) {
        
        self.threadId = threadId
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
    }
	
	
	public required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}

    public func returnDataAsJSON() -> JSON {
        let result: JSON = ["threadId": threadId]

        let resultAsJSON: JSON = ["result":         result,
                                  "hasError":       hasError,
                                  "errorMessage":   errorMessage,
                                  "errorCode":      errorCode]

        return resultAsJSON
    }

}


open class PinUnpinThreadResponse: PinUnpinThreadModel {
    
}

