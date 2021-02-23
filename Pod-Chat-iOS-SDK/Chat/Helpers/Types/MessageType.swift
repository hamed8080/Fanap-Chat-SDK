//
//  MessageType.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 12/6/1398 AP.
//  Copyright © 1398 Mahyar Zhiani. All rights reserved.
//

import Foundation

public enum MessageType : Int , Codable {
    
    case TEXT              = 1
    case VOICE             = 2
    case PICTURE           = 3
    case VIDEO             = 4
    case SOUND             = 5
    case FILE              = 6
    case POD_SPACE_PICTURE = 7
    case POD_SPACE_VIDEO   = 8
    case POD_SPACE_SOUND   = 9
    case POD_SPACE_VOICE   = 10
    case POD_SPACE_FILE    = 11
    case LINK              = 12
}

