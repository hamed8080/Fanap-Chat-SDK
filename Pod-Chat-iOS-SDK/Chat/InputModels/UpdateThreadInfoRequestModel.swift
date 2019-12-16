//
//  UpdateThreadInfoRequestModel.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import Foundation

import SwiftyJSON


open class UpdateThreadInfoRequestModel {
    
    public let description:     String? // Description for thread
    public let image:           String? // URL og thread image to be set
    public let metadata:        JSON?   // New Metadata to be set on thread
    public let threadId:        Int     // Id of thread
    public let title:           String? // New Title for thread
    
    public let typeCode:        String?
    public let uniqueId:        String?
    
    public init(description:        String?,
                image:              String?,
                metadata:           JSON?,
                threadId:           Int,
                title:              String,
                typeCode:           String?,
                uniqueId:           String?) {
        
        self.description    = description
        self.image          = image
        self.metadata       = metadata
        self.threadId       = threadId
        self.title          = title
        self.typeCode       = typeCode
        self.uniqueId       = uniqueId
    }
    
    func convertContentToJSON() -> JSON {
        var content: JSON = [:]
        if let image = self.image {
            content["image"] = JSON(image)
        }
        if let description = self.description {
            content["description"] = JSON(description)
        }
        if let name = self.title {
            content["name"] = JSON(name)
        }
        if let metadata = self.metadata {
            let metadataStr = "\(metadata)"
            content["metadata"] = JSON(metadataStr)
        }
        if let title = self.title {
            content["title"] = JSON(title)
        }
        
        return content
    }
    
}

