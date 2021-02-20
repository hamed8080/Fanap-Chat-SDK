//
//  IsThreadNamePublicRequest.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/20/21.
//

import Foundation

public struct IsThreadNamePublicRequest: Encodable {
	public let name:String
	
	public init(name:String){
		self.name = name
	}
	
}

