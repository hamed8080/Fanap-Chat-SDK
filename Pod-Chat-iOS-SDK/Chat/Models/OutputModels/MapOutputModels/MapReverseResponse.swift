//
//  MapReverseResponse.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/11/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

open class MapReverseResponse: ResponseModel {
    
    
    @available(*,unavailable , renamed: "reverse")
    public var result: MapReverse? = nil
    
    public var reverse: MapReverse? = nil
    
    private enum CodingKeys : String , CodingKey{
        case hasError     = "hasError"
        case message      = "message"
        case errorCode    = "errorCode"
        case reverse      = "reverse"
    }
    
    public required init(from decoder: Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        reverse           = try container.decodeIfPresent(MapReverse.self, forKey: .reverse)
        let errorCode     = try container.decodeIfPresent(Int.self, forKey: .errorCode) ?? 0
        let hasError      = try container.decodeIfPresent(Bool.self, forKey: .hasError) ?? false
        let message       = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        super.init(hasError: hasError, errorMessage: message, errorCode: errorCode)
    }
}
