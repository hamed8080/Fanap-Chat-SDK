//
//  BlockedListRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/1/21.
//

import Foundation
public struct BlockedListRequest : Encodable {
	
	public let count:       Int?
	public let offset:      Int?
	
	public init (count: Int? = 50 , offset: Int = 0){
		self.count      = count
		self.offset     = offset
	}
	
}
