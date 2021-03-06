//
//  UnreadMessageCountRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/27/21.
//

import Foundation
public class UnreadMessageCountRequest: BaseRequest{
	
	let countMutedThreads:Bool
	
	public init (countMutedThreads:Bool = false){
		self.countMutedThreads = countMutedThreads
	}
	
	private enum CodingKeys : String , CodingKey {
		case mute = "mute"
	}
	
	public override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(countMutedThreads, forKey: .mute)
	}
}
