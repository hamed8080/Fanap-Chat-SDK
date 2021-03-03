//
//  NewUpdateThreadInfoRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
public class NewUpdateThreadInfoRequest: BaseRequest {
	
	public let description : String?
	public var metadata    : String?
	public var threadImage : UploadImageRequest?
	public let threadId    : Int
	public let title       : String?
	
	
	public init(description:        String? = nil,
				metadata:           String? = nil,
				threadId:           Int,
				threadImage:        UploadImageRequest? = nil,
				title:              String) {
		
		self.description    = description
		self.metadata       = metadata
		self.threadId       = threadId
		self.threadImage    = threadImage
		self.title          = title
	}
	
	private enum CodingKeys : String , CodingKey{
		case description = "description"
		case name = "name"
		case metadata = "metadata"
	}
	
	public override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(description?.getCustomTextToSendWithRemoveSpaceAndEnter(), forKey: .description)
		try container.encodeIfPresent(title?.getCustomTextToSendWithRemoveSpaceAndEnter(), forKey: .name)
		try container.encodeIfPresent(metadata?.getCustomTextToSendWithRemoveSpaceAndEnter() , forKey: .metadata)
	}
	
}
