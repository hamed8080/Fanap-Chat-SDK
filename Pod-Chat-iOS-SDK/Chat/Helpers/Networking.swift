//
//  Networking.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 5/12/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation
//import FanapPodChatSDK
import Alamofire
import SwiftyJSON
import SwiftyBeaver

struct VoidRequest:Codable{}

class Networking {
    
    public static let sharedInstance = Networking()
    
    func upload(toUrl url:          String,
                withHeaders:        HTTPHeaders?,
                withParameters:     Parameters?,
                isImage:            Bool?,
                isFile:             Bool?,
                dataToSend:         Any?,
                uniqueId:           String?,
                progress:           callbackTypeAliasFloat?,
                completion:         @escaping callbackTypeAlias) {
        
        var uploadProgress: Float = 0
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
//            if let hasImage = isImage, (hasImage == true) {
//                multipartFormData.append(dataToSend as! Data, withName: "file")
//            }
//            if let hasFile = isFile, (hasFile == true) {
//                multipartFormData.append(dataToSend as! Data, withName: "file")
//            }
            multipartFormData.append(dataToSend as! Data, withName: "file")
            
            if let header = withHeaders {
                for (key, value) in header {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            if let parameters = withParameters {
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as String)
                }
            }
        }, to: url) { (myResult) in
            switch myResult {
            case .success(let upload, _, _):
                Chat.sharedInstance.uploadRequest.append((upload: upload, uniqueId: uniqueId!))
                upload.responseJSON(completionHandler: { (response) in
                    if let jsonValue = response.result.value {
                        let jsonResponse: JSON = JSON(jsonValue)
                        completion(jsonResponse)
                    }
                })
                upload.uploadProgress(closure: { (myProgress) in
                    let myProgressFloat: Float = Float(myProgress.fractionCompleted)
                    uploadProgress = myProgressFloat
                    progress?(myProgressFloat)
                })
                upload.responseJSON { response in
                    for (index, item) in Chat.sharedInstance.uploadRequest.enumerated() {
                        if item.uniqueId == uniqueId {
                            Chat.sharedInstance.uploadRequest.remove(at: index)
                        }
                    }
                    
                }
            case .failure(let error):
                let fileInfo = FileInfo(fileName: (withParameters?["fileName"] as? String) ?? "?",
                                        fileSize: (withParameters?["fileSize"] as? Int64) ?? 0)
                let fUploadError = FileUploadEventModel(type:           FileUploadEventTypes.UPLOAD_ERROR,
                                                        errorCode:      nil,
                                                        errorMessage:   "\(ChatErrors.err6200.stringValue()) (Request Error)",
                                                        errorEvent:     error,
                                                        fileInfo:       fileInfo,
                                                        fileObjectData: dataToSend as? Data,
                                                        progress:       uploadProgress,
                                                        userGroupHash:  (withParameters?["userGroupHash"] as? String),
                                                        uniqueId:       uniqueId)
                Chat.sharedInstance.delegate?.fileUploadEvents(model: fUploadError)
                completion(error)
            }
        }
    }
    
    
    func download(fromUrl urlStr:       String,
                  withMethod:           HTTPMethod,
                  withHeaders:          HTTPHeaders?,
                  withParameters:       Parameters?,
                  progress:             callbackTypeAliasFloat?,
                  downloadReturnData:   @escaping (Data?, JSON) -> ()) {
        
        let url = URL(string: urlStr)!
        
        Alamofire.request(url,
                          method:       withMethod,
                          parameters:   withParameters,
                          encoding:     URLEncoding(destination: .queryString),
                          headers:      withHeaders)
        .downloadProgress(closure: { (downloadProgress) in
            let myProgressFloat: Float = Float(downloadProgress.fractionCompleted)
            progress?(myProgressFloat)
        })
        .responseData { (myResponse) in
            if myResponse.result.isSuccess {
                if let downloadedData = myResponse.data {
                    if let response = myResponse.response {
                        var resJSON: JSON = [:]
                        
                        if urlStr.contains("neshan") {
                            downloadReturnData(downloadedData, resJSON)
                            return
                        }
                        
                        let headerResponse = response.allHeaderFields
                        if let contentType  = headerResponse["Content-Type"] as? String,
                            let fileType    = contentType.components(separatedBy: "/").last {
                                resJSON["type"] = JSON(fileType)
                        }
                        if let contentSizeStr   = headerResponse["Content-Length"] as? String,
                            let contentSize     = Int(contentSizeStr) {
                                resJSON["size"] = JSON(contentSize)
                        }
                        if let contentDisposition = headerResponse["Content-Disposition"] as? String {
                            if let theFileName = contentDisposition.components(separatedBy: "=").last?.replacingOccurrences(of: "\"", with: "") {
                                resJSON["name"] = JSON(theFileName)
                            }
                            // return the Data:
                            downloadReturnData(downloadedData, resJSON)
                        } else {
                            // an error accured, so return the error:
                            let returnJSON: JSON = ["hasError": true, "errorCode": 999]
                            Chat.sharedInstance.delegate?.chatError(errorCode:      999,
                                                                    errorMessage:   "error on downloading File",
                                                                    errorResult:    nil)
                            downloadReturnData(nil, returnJSON)
                        }
                    }
                }
            } else {
                Chat.sharedInstance.delegate?.chatError(errorCode:      -1,
                                                        errorMessage:   "error on downloading File",
                                                        errorResult:    myResponse.error)
            }
        }
        
    }
    
    @available(*,deprecated  , renamed:"request" , message:"use request method instead")
    func requesttWithJSONresponse(from urlStr:      String,
                                  withMethod:       HTTPMethod,
                                  withHeaders:      HTTPHeaders?,
                                  withParameters:   Parameters?,
                                  completion:       @escaping callbackTypeAlias) {
        
        guard let url = URL(string: urlStr) else { print("could not open url, it was nil"); return }
        Alamofire.request(url,
                          method:       withMethod,
                          parameters:   withParameters,
                          headers:      withHeaders)
            .responseJSON { (myResponse) in
            if myResponse.result.isSuccess {
                if let jsonValue = myResponse.result.value {
                    let jsonResponse: JSON = JSON(jsonValue)
                    completion(jsonResponse)
                }
            } else {
//                log.error("Response of GerRequest is Failed)", context: "Chat")
                if let error = myResponse.error {
                    let myJson: JSON = ["hasError": true,
                                        "errorCode": 6200,
                                        "errorMessage": "\(ChatErrors.err6200.stringValue()) \(error)",
                                        "errorEvent": error.localizedDescription]
                    completion(myJson)
                }
            }
        }
    }
    
    class func request<D:Codable>(ofType:D.Type,
                                  from urlStr:      String,
                                  withMethod:       HTTPMethod,
                                  withHeaders:      HTTPHeaders?,
                                  withParameters:   Parameters?,
                                  completion:       ((D?)->())? = nil ) {
        
        guard let url = URL(string: urlStr) else { print("could not open url, it was nil"); return }
        Alamofire.request(url,
                          method:       withMethod,
                          parameters:   withParameters,
                          headers:      withHeaders)
            .responseData { (myResponse) in
            if myResponse.result.isSuccess , let data = myResponse.result.value , let codable = try? JSONDecoder().decode(D.self, from: data){
                    completion?(codable)
            }else if let error = myResponse.error {
                    //FIXME: add error
                    completion?(nil)
            }
        }
    }
    
    
    func requestWithStringResponse(from urlStr:     String,
                                   withMethod:      HTTPMethod,
                                   withHeaders:     HTTPHeaders?,
                                   withParameters:  Parameters?,
                                   completion:      @escaping callbackTypeAlias) {
        
        let url = URL(string: urlStr)!
        Alamofire.request(url,
                          method:       withMethod,
                          parameters:   withParameters,
                          headers:      withHeaders)
            .responseString { (response) in
            if response.result.isSuccess {
                let stringToReturn: String = response.result.value!
                completion(stringToReturn)
            } else {
//                log.error("Response of GerRequest is Failed)", context: "Chat")
                if let error = response.error {
                    let myJson: JSON = ["hasError": true,
                                        "errorCode": 6200,
                                        "errorMessage": "\(ChatErrors.err6200.stringValue()) \(error)",
                                        "errorEvent": error.localizedDescription]
                    completion(myJson)
                }
            }
        }
    }
    
    
}
