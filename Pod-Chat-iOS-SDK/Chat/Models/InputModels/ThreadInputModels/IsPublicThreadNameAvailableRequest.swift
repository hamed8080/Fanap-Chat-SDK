//
//  IsPublicThreadNameAvailableRequest.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 12/25/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import SwiftyJSON


@available(*,deprecated , message:"this class remoed in future realese . use request method")
open class IsPublicThreadNameAvailableRequest: RequestModelDelegates , Encodable {
    
    public let uniqueName:  String
    
    public let typeCode:    String?
    public let uniqueId:    String
    
    public init(uniqueName: String,
                typeCode:   String?,
                uniqueId:   String?) {
        
        self.uniqueName = uniqueName
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
    public init(name:       String,
                typeCode:   String?,
                uniqueId:   String?) {
        
        self.uniqueName = name
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
    
    public func convertContentToJSON() -> JSON {
        var content: JSON = [:]
        content["name"] = JSON(self.uniqueName)
        return content
    }
    
    public func convertContentToJSONArray() -> [JSON] {
        return []
    }
    
}


/// MARK: -  this class will be deprecate (use this class instead: 'IsNameAvailableThreadRequest')
open class IsNameAvailableThreadRequestModel: IsPublicThreadNameAvailableRequest {
    
}
