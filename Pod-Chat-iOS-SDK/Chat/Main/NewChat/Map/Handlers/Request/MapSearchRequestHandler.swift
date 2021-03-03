//
//  MapSearchRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/3/21.
//

import Foundation
import Alamofire

class MapSearchRequestHandler {
	
	class func handle( req:MapSearchRequest , chat:Chat ,uniqueIdResult:((String)->())? = nil,completion: @escaping (ChatResponse)->()){
		guard  let createChatModel = chat.createChatModel, let mapApiKey = createChatModel.mapApiKey else {return}
		let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_SEARCH.rawValue)"
		let headers:  HTTPHeaders = ["Api-Key":  mapApiKey]
		chat.restApiRequest(req,
							decodeType: NewMapSearchResponse.self,
							url: url,
							headers: headers,
							typeCode: req.typeCode,
							uniqueIdResult:uniqueIdResult,
							completion: completion
		)
	}
	
}
