//
//  NewUpdateChatProfile.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation

public class NewUpdateChatProfile: BaseRequest {
	
	public let bio:         String?
	public let metadata:    String?
	
	public init(bio: String?, metadata:   String? = nil) {
		
		self.bio        = bio
		self.metadata   = metadata
	}
	
	private enum CodingKeys : String , CodingKey{
		case bio = "bio"
		case metadata = "metadata"
	}
	
	public override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(bio?.getCustomTextToSendWithRemoveSpaceAndEnter(), forKey: .bio)
		try container.encodeIfPresent(metadata?.getCustomTextToSendWithRemoveSpaceAndEnter(), forKey: .metadata)
	}
}
