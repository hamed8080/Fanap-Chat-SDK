//
//  MapRoutingRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
import Alamofire

class MapRoutingRequestHandler {
	
	class func handle( req:NewMapRoutingRequest , chat:Chat ,uniqueIdResult:((String)->())? = nil,completion: @escaping (ChatResponse)->()){
		guard  let createChatModel = chat.createChatModel, let mapApiKey = createChatModel.mapApiKey else {return}
		let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_ROUTING.rawValue)"
		let headers:  HTTPHeaders = ["Api-Key":  mapApiKey]
		chat.restApiRequest(req,
							decodeType: NewMapRoutingResponse.self,
							url: url,
							headers: headers,
							typeCode: req.typeCode,
							uniqueIdResult:uniqueIdResult,
							completion: completion
		)
	}
	
}
