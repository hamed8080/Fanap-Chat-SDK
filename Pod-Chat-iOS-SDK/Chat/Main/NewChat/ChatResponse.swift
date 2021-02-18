//
//  ChatResponse.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation

public struct ChatError:Decodable{
	let code:Int?
	let message:String?
	let content:String?
}
