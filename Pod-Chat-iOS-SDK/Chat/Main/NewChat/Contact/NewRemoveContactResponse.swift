//
//  NewRemoveContactResponse.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/2/21.
//

import Foundation
public class NewRemoveContactResponse :  NewResponseModel {
    
    public var deteled:  Bool
    
    private enum CodingKeys : String ,CodingKey{
        case hasError     = "hasError"
        case message      = "message"
        case errorCode    = "errorCode"
        case result       = "result"
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let hasError = try container.decodeIfPresent(Bool.self, forKey: .hasError) ?? false
        let code = try container.decodeIfPresent(Int.self, forKey: .errorCode) ?? 0
        let message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.deteled = try container.decodeIfPresent(Bool.self, forKey: .result) ?? false
        super.init(hasError: hasError, errorMessage: message, errorCode: code)
    }
}
