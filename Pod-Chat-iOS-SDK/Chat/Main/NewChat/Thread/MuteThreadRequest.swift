//
//  MuteThreadRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/20/21.
//

import Foundation
public struct MuteThreadRequest : Encodable {
	
	public let threadId:Int
	
	public init(threadId:Int) {
		self.threadId = threadId
	}
	
	private enum CodingKeys : String , CodingKey{
		case threadId = "subjectId"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(threadId, forKey: .threadId)
	}
}
