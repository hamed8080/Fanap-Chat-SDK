//
//  NewSendAsyncMessageVO.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 10/4/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation

struct NewSendAsyncMessageVO : Codable{
	
	var content:        String
	let ttl : Int
	let peerName:       String
	let priority:       Int
	var pushMsgType:    Int? = nil
	
	
	public init(content: String, ttl: Int, peerName: String, priority: Int, pushMsgType: Int? = nil) {
		self.content = content
		self.ttl = ttl
		self.peerName = peerName
		self.priority = priority
		self.pushMsgType = pushMsgType
	}
	
	private enum CodingKeys : String ,CodingKey {
		case content     = "content"
		case ttl         = "ttl"
		case peerName    = "peerName"
		case priority    = "priority"
		case pushMsgType = "pushMsgType"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		content = try container.decode(String.self, forKey: .content)
		ttl = try container.decode(Int.self, forKey: .ttl)
		peerName = try container.decode(String.self, forKey: .peerName)
		priority = try container.decodeIfPresent(Int.self, forKey: .priority) ?? 1
		pushMsgType = try container.decodeIfPresent(Int.self, forKey: .pushMsgType)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encodeIfPresent(content, forKey: .content)
		try? container.encodeIfPresent(peerName, forKey: .peerName)
		try? container.encodeIfPresent(priority, forKey: .priority)
		try? container.encodeIfPresent(ttl, forKey: .ttl)
	}
	
}
