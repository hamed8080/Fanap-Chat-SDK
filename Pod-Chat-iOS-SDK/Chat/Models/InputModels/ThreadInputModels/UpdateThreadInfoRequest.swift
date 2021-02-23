//
//  UpdateThreadInfoRequest.swift
//  Chat
//
//  Created by Mahyar Zhiani on 10/1/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//

import FanapPodAsyncSDK
import SwiftyJSON
import Foundation

open class UpdateThreadInfoRequest: RequestModelDelegates  , Encodable {
    
    public let description : String?
    public var metadata    : String?
    public var threadImage : UploadImageRequest?
    public let threadId    : Int
    public let title       : String?
    
    
    @available(*,deprecated , message: "removed in future release. use request method")
    public let typeCode:        String?
    @available(*,deprecated , message: "removed in future release. use request method")
    public let uniqueId:        String
    
    public init(description:        String? = nil,
                metadata:           String? = nil,
                threadId:           Int,
                threadImage:        UploadImageRequest? = nil,
                title:              String,
                typeCode:           String? = nil,
                uniqueId:           String? = nil) {
        
        self.description    = description
        self.metadata       = metadata
        self.threadId       = threadId
        self.threadImage    = threadImage
        self.title          = title
        
        self.typeCode       = typeCode
        self.uniqueId       = uniqueId ?? UUID().uuidString
    }
    
    public func convertContentToJSON() -> JSON {
        var content: JSON = [:]
//        if let image_ = self.image {
//            content["image"] = JSON(image_)
//        }
        if let description_ = self.description {
            let theDecription = MakeCustomTextToSend(message: description_).replaceSpaceEnterWithSpecificCharecters()
            content["description"] = JSON(theDecription)
        }
        if let name_ = self.title {
            let theName = MakeCustomTextToSend(message: name_).replaceSpaceEnterWithSpecificCharecters()
            content["name"] = JSON(theName)
        }
        if let metadata_ = self.metadata {
            let metadataStr = MakeCustomTextToSend(message: metadata_).replaceSpaceEnterWithSpecificCharecters()
            content["metadata"] = JSON(metadataStr)
        }
        
        return content
    }
    
    public func convertContentToJSONArray() -> [JSON] {
        return []
    }
	
	private enum CodingKeys : String , CodingKey{
		case description = "description"
		case name = "name"
		case metadata = "metadata"
	}
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(description?.getCustomTextToSendWithRemoveSpaceAndEnter(), forKey: .description)
        try container.encodeIfPresent(title?.getCustomTextToSendWithRemoveSpaceAndEnter(), forKey: .name)
        try container.encodeIfPresent(metadata?.getCustomTextToSendWithRemoveSpaceAndEnter() , forKey: .metadata)
    }
    
}

@available(* , deprecated , message: "remoed in future release")
open class UpdateThreadInfoRequestModel: UpdateThreadInfoRequest {
    
}

