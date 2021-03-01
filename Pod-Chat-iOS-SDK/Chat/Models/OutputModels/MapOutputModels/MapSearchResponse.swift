//
//  MapSearchResponse.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 10/11/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

open class MapSearchModel: ResponseModel, ResponseModelDelegates {
    
    public var result:  MapSearch
    
    public init(messageContent: JSON,
                hasError:       Bool,
                errorMessage:   String,
                errorCode:      Int) {
        
        self.result = MapSearch(messageContent: messageContent)
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
    }
    
    public init(hasError:       Bool,
                errorMessage:   String?,
                errorCode:      Int?,
                searchObject:   MapSearch) {
        
        self.result = searchObject
        super.init(hasError:        hasError,
                   errorMessage:    errorMessage ?? "",
                   errorCode:       errorCode ?? 0)
    }
	
	public required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
    
    public func returnDataAsJSON() -> JSON {
        let theResult: JSON = ["reverse":   result.formatToJSON()]
        let finalResult: JSON = ["result":          theResult,
                                 "hasError":        hasError,
                                 "errorMessage":    errorMessage,
                                 "errorCode":       errorCode]
        
        return finalResult
    }
    
}


open class MapSearchResponse: MapSearchModel {
    
}


