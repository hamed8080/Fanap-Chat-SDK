//
//  DownloadImageResponse.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 9/24/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

open class DownloadImageModel: ResponseModel, ResponseModelDelegates {
    
    public let downloadImage:   ImageObject?
    
    public init(messageContentJSON: JSON?,
                errorCode:          Int,
                errorMessage:       String,
                hasError:           Bool) {
        
        if let content = messageContentJSON {
            self.downloadImage = ImageObject(messageContent: content)
        } else {
            downloadImage = nil
        }
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
    }
    
    public init(messageContentModel:    ImageObject?,
                errorCode:              Int,
                errorMessage:           String,
                hasError:               Bool) {
        
        if let myImage = messageContentModel {
            self.downloadImage    = myImage
        } else {
            downloadImage = nil
        }
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
    }
	
	
	public required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
    
    public func returnDataAsJSON() -> JSON {
        let result: JSON = ["downloadImage":    downloadImage?.formatToJSON() ?? NSNull()]
        
        let resultAsJSON: JSON = ["result":         result,
                                  "errorCode":      errorCode,
                                  "errorMessage":   errorMessage,
                                  "hasError":       hasError]
        
        return resultAsJSON
    }
    
}


open class DownloadImageResponse: DownloadImageModel {
    
}

