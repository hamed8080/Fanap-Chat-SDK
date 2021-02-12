//
//  MapRoutingResponse.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/12/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

open class MapRoutingResponse: ResponseModel {
    
    public var routes:  [Route]? = nil
	
    private enum CodingKeys : String , CodingKey{
        case routes       = "routes"
        case hasError     = "hasError"
        case errorMessage = "errorMessage"
        case errorCode    = "errorCode"
    }
    
	public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.routes = try container.decodeIfPresent([Route].self, forKey: .routes) ?? nil
        let hasError = (try container.decodeIfPresent(Bool.self, forKey: .hasError)) ?? false
        let errorMessage = (try container.decodeIfPresent(String.self, forKey: .errorMessage)) ?? ""
        let errorCode = (try container.decodeIfPresent(Int.self, forKey: .errorCode)) ?? 0
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
	}
}

