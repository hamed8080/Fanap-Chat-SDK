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
        mapReverse(mapReverseInput,
                   completion: completion,
                   uniqueIdResult: uniqueId)
        
    }
    
    
    /// MapRevers:
    /// get location details from client location.
    ///
    /// By calling this function, HTTP request of type (REVERSE to the MAP_ADDRESS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "MapReverseRequest" to this function
    ///
    /// Outputs:
    /// - It has 2 callbacks as responses.
    ///
    /// - parameter _ : (input) you have to send your parameters insid this model. (MapReverseRequest)
    /// - parameter uniqueIdResult:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! MapReverseModel)
    public func mapReverse(_ mapReverseRequest:MapReverseRequest ,
                           completion:@escaping callbackTypeAlias,
                           uniqueIdResult:((String)->())? = nil ){
        guard let createChatModel = createChatModel else {return}
        guard let mapApiKey = createChatModel.mapApiKey else {return}
        uniqueIdResult?(mapReverseRequest.uniqueId)
        let url = "\(createChatModel.mapServer)\(SERVICES_PATH.REVERSE.rawValue)"
        let headers:  HTTPHeaders = ["Api-Key":   mapApiKey]
        Networking.request(ofType: MapReverse.self,
                           from: url,
                           withMethod: .get,
                           withHeaders: headers,
                           encodableRequest: mapReverseRequest) { mapReverseResponse in
            if let mapReverseResponse = mapReverseResponse {
                completion(mapReverseResponse)
            }
        }
    }
    
    @available(*, deprecated , message: "use another mapRouting method with uniqueIdresult.this removed in future release.")
    public func mapRouting(inputModel mapRoutingInput: MapRoutingRequest,
                           uniqueId:        @escaping (String) -> (),
                           completion:      @escaping callbackTypeAlias) {
      
        mapRouting(mapRoutingInput, completion: completion, uniqueIdResult: uniqueId)
    }
    
    /// MapRouting:
    /// send 2 locations, and then give routing suggesston.
    ///
    /// By calling this function, HTTP request of type (SEARCH to the MAP_ADDRESS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "MapRoutingRequest" to this function
    ///
    /// Outputs:
    /// - It has 2 callbacks as responses.
    ///
    /// - parameter inputModel: (input) you have to send your parameters insid this model. (MapRoutingRequest)
    /// - parameter uniqueId:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! MapRoutingModel)
    public func mapRouting(_ mapRoutingRequest:MapRoutingRequest , completion: @escaping callbackTypeAlias , uniqueIdResult: ((String)->())? = nil){
        guard let createChatModel = createChatModel else {return}
        guard let mapApiKey = createChatModel.mapApiKey else {return}
        uniqueIdResult?(generateUUID())
        
        let url = "\(createChatModel.mapServer)\(SERVICES_PATH.ROUTING.rawValue)"
//        let url = "https://api.neshan.org/v3/direction?parameters"
        let headers:    HTTPHeaders = ["Api-Key": mapApiKey]
        Networking.request(ofType: MapRoutingResponse.self,
                           from: url,
                           withMethod: .get,
                           withHeaders: headers,
                           encodableRequest: mapRoutingRequest) { mapRoutingresponse in
            if let mapRoutingresponse = mapRoutingresponse {
                completion(mapRoutingresponse)
            }
        }
    }
    
    /// MapSearch:
    /// search near thing inside the map, whoes where close to the client location.
    ///
    /// By calling this function, HTTP request of type (SEARCH to the MAP_ADDRESS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "MapSearchRequest" to this function
    ///
    /// Outputs:
    /// - It has 2 callbacks as responses.
    ///
    /// - parameter inputModel: (input) you have to send your parameters insid this model. (MapSearchRequest)
    /// - parameter uniqueId:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! MapSearchModel)
    public func mapSearch(inputModel mapSearchInput:   MapSearchRequest,
                          uniqueId:         @escaping (String) -> (),
                          completion:       @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        guard let mapApiKey = createChatModel.mapApiKey else {return}
        let theUniqueId = generateUUID()
        uniqueId(theUniqueId)
        
        let url = "\(createChatModel.mapServer)\(SERVICES_PATH.SEARCH.rawValue)"
        let method:     HTTPMethod  = HTTPMethod.get
        let headers:    HTTPHeaders = ["Api-Key": mapApiKey]
        let parameters: Parameters  = ["lat":   mapSearchInput.lat,
                                       "lng":   mapSearchInput.lng,
                                       "term":  mapSearchInput.term]
        
        Networking.sharedInstance.requesttWithJSONresponse(from:            url,
                                                           withMethod:      method,
                                                           withHeaders:     headers,
                                                           withParameters:  parameters)
        { (jsonResponse) in
            if let theResponse = jsonResponse as? JSON {
                let mapSearchModel = MapSearchModel(messageContent: theResponse,
                                                    hasError:       false,
                                                    errorMessage:   "",
                                                    errorCode:      0)
                completion(mapSearchModel)
            }
        }
        
    }
    
    
    /// MapStaticImage:
    /// get a static image from the map based on the location that user wants.
    ///
    /// By calling this function, HTTP request of type (STATIC_IMAGE to the MAP_ADDRESS) will send throut Chat-SDK,
    /// then the response will come back as callbacks to client whose calls this function.
    ///
    /// Inputs:
    /// - you have to send your parameters as "MapStaticImageRequest" to this function
    ///
    /// Outputs:
    /// - It has 2 callbacks as responses.
    ///
    /// - parameter inputModel: (input) you have to send your parameters insid this model. (MapStaticImageRequest)
    /// - parameter uniqueId:   (response) it will returns the request 'UniqueId' that will send to server. (String)
    /// - parameter progress:   (response)  it will returns the progress of the downloading request by a value between 0 and 1. (Float)
    /// - parameter completion: (response) it will returns the response that comes from server to this request. (Any as! Data)
    public func mapStaticImage(inputModel mapStaticImageInput: MapStaticImageRequest,
                               uniqueId:            @escaping (String) -> (),
                               progress:            @escaping (Float) -> (),
                               completion:          @escaping callbackTypeAlias) {
        guard let createChatModel = createChatModel else {return}
        guard let mapApiKey = createChatModel.mapApiKey else {return}
        let theUniqueId = generateUUID()
        uniqueId(theUniqueId)
        
        let url = "\(createChatModel.mapServer)\(SERVICES_PATH.STATIC_IMAGE.rawValue)"
        let method:     HTTPMethod  = HTTPMethod.get
        let parameters: Parameters  = ["key":       mapApiKey,
                                       "type":      mapStaticImageInput.type,
                                       "zoom":      mapStaticImageInput.zoom,
                                       "center":    "\(mapStaticImageInput.center.lat),\(mapStaticImageInput.center.lng)",
                                       "width":     mapStaticImageInput.width,
                                       "height":    mapStaticImageInput.height]
        
        Networking.sharedInstance.download(fromUrl:         url,
                                           withMethod:      method,
                                           withHeaders:     nil,
                                           withParameters:  parameters
        , progress: { (downloadProgress) in
            progress(downloadProgress)
        }) { (myResponse, jsonResponse) in
            guard let image = myResponse else { print("Value is empty!!!"); return }
            completion(image)
        }
        
    }
    
    
    
}
