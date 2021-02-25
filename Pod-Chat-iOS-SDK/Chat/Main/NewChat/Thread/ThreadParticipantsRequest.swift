//
//  ThreadParticipantsRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/24/21.
//

import Foundation
public struct ThreadParticipantsRequest : Encodable {
	
	public let count:           Int?
	public let offset:          Int?
	
	public init (offset:Int = 0, count:Int = 50 ){
		self.count = count
		self.offset = offset
	}
}
