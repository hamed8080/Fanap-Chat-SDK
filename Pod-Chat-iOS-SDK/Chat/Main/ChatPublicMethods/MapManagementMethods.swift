//
//  MapManagementMethods.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 3/21/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
import FanapPodAsyncSDK
import SwiftyJSON
import Alamofire


// MARK: - Public Methods -
// MARK: - Map Management

extension Chat {
    
    @available(*,deprecated , message: "use the another mapReverse method , removed in future release.")
    public func mapReverse(inputModel mapReverseInput: MapReverseRequest,
                           uniqueId:        @escaping (String) -> (),
                           completion:      @escaping callbackTypeAlias) {
        
    
        mapReverseInput.uniqueId =  generateUUID()
        guard let createChatModel = createChatModel else {return}
        guard let mapApiKey = createChatModel.mapApiKey else {return}
        uniqueId(mapReverseInput.uniqueId)
        let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_REVERSE.rawValue)"
        let headers:  HTTPHeaders = ["Api-Key":   mapApiKey]
        Networking.request(ofType: MapReverse.self,
                           from: url,
                           withMethod: .get,
                           withHeaders: headers,
                           encodableRequest: mapReverseInput) { mapReverseResponse in
            if let mapReverseResponse = mapReverseResponse {
                completion(mapReverseResponse)
            }
        }
        
    }
    
    @available(*, deprecated , message: "use another mapRouting method with uniqueIdresult.this removed in future release.")
    public func mapRouting(inputModel mapRoutingInput: MapRoutingRequest,
                           uniqueId:        @escaping (String) -> (),
                           completion:      @escaping callbackTypeAlias) {
      
        guard let createChatModel = createChatModel else {return}
        guard let mapApiKey = createChatModel.mapApiKey else {return}
        uniqueId(generateUUID())
        
        let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_ROUTING.rawValue)"
//        let url = "https://api.neshan.org/v3/direction?parameters"
        let headers:    HTTPHeaders = ["Api-Key": mapApiKey]
        Networking.request(ofType: MapRoutingResponse.self,
                           from: url,
                           withMethod: .get,
                           withHeaders: headers,
                           encodableRequest: mapRoutingInput) { mapRoutingresponse in
            if let mapRoutingresponse = mapRoutingresponse {
                completion(mapRoutingresponse)
            }
        }
    }
    
    
	@available(*, deprecated , message: "use another mapSearch method with uniqueIdresult.this removed in future release.")
    public func mapSearch(inputModel mapSearchInput:   MapSearchRequest,
                          uniqueId:         @escaping (String) -> (),
                          completion:       @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        guard let mapApiKey = createChatModel.mapApiKey else {return}
        let theUniqueId = generateUUID()
        uniqueId(theUniqueId)
        
        let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_SEARCH.rawValue)"
        let headers:    HTTPHeaders = ["Api-Key": mapApiKey]
        Networking.request(ofType: MapSearchResponse.self,
                           from: url,
                           withMethod: .get,
                           withHeaders: headers,
                           encodableRequest: mapSearchInput) { mapSearchResponse in
            if let mapSearchResponse = mapSearchResponse{
                completion(mapSearchResponse)
            }
        }
    }
    
	@available(*, deprecated , message: "use another mapStaticImage method with uniqueIdresult.this removed in future release.")
    public func mapStaticImage(inputModel mapStaticImageInput: MapStaticImageRequest,
                               uniqueId:            @escaping (String) -> (),
                               progress:            @escaping (Float) -> (),
                               completion:          @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        guard let mapApiKey = createChatModel.mapApiKey else {return}
        mapStaticImageInput.key = mapApiKey
        let theUniqueId = generateUUID()
        uniqueId(theUniqueId)
        
        let url = "\(createChatModel.mapServer)\(SERVICES_PATH.MAP_STATIC_IMAGE.rawValue)"
        Networking.sharedInstance.download(fromUrl:         url,
                                           withMethod:      .get,
                                           withHeaders:     nil,
                                           withParameters: try! mapStaticImageInput.asDictionary(),
                                           progress: { progressValue in
                                            progress(progressValue)
                                           }) { (myResponse, jsonResponse) in
            guard let image = myResponse else { print("Value is empty!!!"); return }
            completion(image)
        }
    }
    
}
