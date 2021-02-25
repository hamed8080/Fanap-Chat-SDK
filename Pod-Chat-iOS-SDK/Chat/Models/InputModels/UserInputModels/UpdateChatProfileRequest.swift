//
//  UpdateChatProfileRequest.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 11/20/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import FanapPodAsyncSDK
import SwiftyJSON

open class UpdateChatProfileRequest: RequestModelDelegates , Encodable {
    
    public let bio:         String?
    public let metadata:    String?
    
	@available(*,deprecated , message: "removed in future release. use request method.")
    public let typeCode:    String?
	@available(*,deprecated , message: "removed in future release. use request method.")
    public let uniqueId:    String
    
    public init(bio:        String?,
                metadata:   String? = nil,
                typeCode:   String? = nil,
                uniqueId:   String? = nil) {
        
        self.bio        = bio
        self.metadata   = metadata
        
        self.typeCode   = typeCode
        self.uniqueId   = uniqueId ?? UUID().uuidString
    }
    
    
    public func convertContentToJSON() -> JSON {
        var content: JSON = [:]
        if let myBio = bio {
            let theBio = MakeCustomTextToSend(message: myBio).replaceSpaceEnterWithSpecificCharecters()
            content["bio"] = JSON(theBio)
        }
        if let myMetadata = metadata {
            let theMeta = MakeCustomTextToSend(message: myMetadata).replaceSpaceEnterWithSpecificCharecters()
            content["metadata"] = JSON(theMeta)
        }
        return content
    }
    
    public func convertContentToJSONArray() -> [JSON] {
        return []
    }
	
	private enum CodingKeys : String , CodingKey{
		case bio = "bio"
		case metadata = "metadata"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(bio?.getCustomTextToSendWithRemoveSpaceAndEnter(), forKey: .bio)
		try container.encodeIfPresent(metadata?.getCustomTextToSendWithRemoveSpaceAndEnter(), forKey: .metadata)
	}
    
}

@available(*,deprecated , message: "removed in future release. use request method.")
open class SetProfileRequestModel: UpdateChatProfileRequest {
    
}
