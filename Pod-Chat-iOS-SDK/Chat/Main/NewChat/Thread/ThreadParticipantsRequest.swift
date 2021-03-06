//
//  ThreadParticipantsRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/24/21.
//

import Foundation
public class ThreadParticipantsRequest : BaseRequest {
	
	public let count:           Int?
	public let offset:          Int?
	public let threadId:Int
	
	public init (threadId:Int,offset:Int = 0, count:Int = 50 ){
		self.count = count
		self.offset = offset
		self.threadId = threadId
	}
	
	private enum CodingKeys:String ,CodingKey{
		case count = "count"
		case offset = "offset"
	}
	
	public override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encodeIfPresent(count, forKey: .count)
		try? container.encodeIfPresent(offset, forKey: .offset)
	}
}
