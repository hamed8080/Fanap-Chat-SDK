//
//  DownloadMapStaticImageRequestHandler.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation
import Alamofire

class DownloadMapStaticImageRequestHandler {
	
	private init(){}
	
	internal class func handle(req:NewMapStaticImageRequest ,
							   createChatModel:CreateChatModel ,
							   completion:@escaping (ChatResponse)->(),
							   downloadProgress:((Float) -> ())? = nil)
	{
		
		guard let mapApiKey = createChatModel.mapApiKey else{return}
		req.key = mapApiKey
		let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_STATIC_IMAGE.rawValue)"
		Networking.sharedInstance.download(fromUrl:         url,
										   withMethod:      .get,
										   withHeaders:     nil,
										   withParameters: try! req.asDictionary(),
										   progress: { progress in
											downloadProgress?(progress)
										   }) { (myResponse, jsonResponse) in
			guard let image = myResponse else { print("Value is empty!!!"); return }
			let response = ChatResponse(result: image)
			completion(response)
		}
	}
	
}
