//
//  NewContactResponse.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/12/21.
//

import Foundation
public class NewContactResponse : NewResponseModel{
    
    public var contentCount:       Int = 0
    public var contacts:           [Contact] = []
    
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
        super.init(hasError: hasError, errorMessage: message, errorCode: errorCode)
    }
}
