//
//  NewPinUnpinMessageRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation

public class NewPinUnpinMessageRequest: BaseRequest {
	
	public let messageId:   Int
	public let notifyAll:   Bool
	
	public init(messageId:  Int, notifyAll:  Bool = false) {
		self.messageId  = messageId
		self.notifyAll  = notifyAll
	}
	
	private enum CodingKeys : String , CodingKey{
		case notifyAll = "notifyAll"
	}
	
	public override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try? container.encode(notifyAll, forKey: .notifyAll)
	}
}
