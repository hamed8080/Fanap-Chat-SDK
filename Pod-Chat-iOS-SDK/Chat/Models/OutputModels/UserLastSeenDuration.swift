//
//  UserLastSeenDuration.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 2/4/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//

import Foundation
import SwiftyJSON

open class UserLastSeenDuration :Codable{
    
    public var userId : Int
    public var time   : Int
    
    init(userId: Int, time: Int) {
        self.userId = userId
        self.time   = time
    }

}

