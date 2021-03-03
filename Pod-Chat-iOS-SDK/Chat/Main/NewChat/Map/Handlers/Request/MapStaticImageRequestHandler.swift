//
//  MapStaticImageRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
import Alamofire

class MapStaticImageRequestHandler {
	
	class func handle( req:NewMapStaticImageRequest , chat:Chat ,uniqueIdResult:((String)->())? = nil,completion: @escaping (ChatResponse)->()){
		guard  let createChatModel = chat.createChatModel else {return}
		DownloadMapStaticImageRequestHandler.handle(req:req , createChatModel: createChatModel, completion: completion)
	}
	
}
