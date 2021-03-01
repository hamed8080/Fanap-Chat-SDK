//
//  NotSeenDurationRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/1/21.
//

import Foundation
public struct NotSeenDurationRequest: Encodable {
	
	public let userIds     : [Int]

	public init(userIds: [Int]) {
		self.userIds    = userIds
	}
	
}
