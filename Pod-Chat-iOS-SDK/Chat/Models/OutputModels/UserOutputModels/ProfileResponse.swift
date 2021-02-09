//
//  ProfileResponse.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 11/20/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

open class ProfileModel: ResponseModel, ResponseModelDelegates {
    
    public let profile: Profile
    
    public init(messageContent: JSON,
                hasError:       Bool,
                errorMessage:   String,
                errorCode:      Int) {
        
        self.profile = Profile(messageContent: messageContent)
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
    }
    
    public init(profileObject:  Profile,
                hasError:       Bool,
                errorMessage:   String,
                errorCode:      Int) {
        
        self.profile = profileObject
        super.init(hasError: hasError, errorMessage: errorMessage, errorCode: errorCode)
    }
	
	public required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
	
    public func returnDataAsJSON() -> JSON {
        let result: JSON = ["profile":  profile.formatToJSON()]
        
        let resultAsJSON: JSON = ["result":         result,
                                  "hasError":       hasError,
                                  "errorMessage":   errorMessage,
                                  "errorCode":      errorCode]
        
        return resultAsJSON
    }
    
}


open class ProfileResponse: ProfileModel {
    
}

