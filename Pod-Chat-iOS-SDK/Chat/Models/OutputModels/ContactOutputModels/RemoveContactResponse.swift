//
//  RemoveContactResponse.swift
//  Chat
//
//  Created by Mahyar Zhiani on 7/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class RemoveContactResponse: ResponseModel {
    
    public var result:  Bool
    
    private enum CodingKeys: String , CodingKey{
        case result       = "result"
        case hasError     = "hasError"
        case message      = "message"
        case errorCode    = "errorCode"
    }
    
	public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let hasError = try container.decodeIfPresent(Bool.self, forKey: .hasError)
        let message = try container.decodeIfPresent(String.self, forKey: .message)
        let errorCode = try container.decodeIfPresent(Int.self, forKey: .errorCode)
        self.result = try container.decodeIfPresent(Bool.self, forKey: .result) ?? false
        super.init(hasError: hasError ?? false, errorMessage: message ?? "", errorCode: errorCode ?? 0 )
	}
    
}


