//
//  NewResponseModel.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 3/12/21.
//

import Foundation
open class NewResponseModel : Codable{
    
    var hasError:       Bool
    var errorMessage:   String
    var errorCode:      Int
    
    public init(hasError: Bool,
                errorMessage: String,
                errorCode: Int) {
        
        self.hasError           = hasError
        self.errorMessage       = errorMessage
        self.errorCode          = errorCode
    }
    
}
