//
//  NewCreateBotRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
public class NewCreateBotRequest: BaseRequest {
	
	public var botName:String
	
	public init(botName:String){
		self.botName = botName
	}
}
