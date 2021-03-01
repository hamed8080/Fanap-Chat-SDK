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
	
	@available(*,deprecated , message: "removed in future release.")
    public func returnIntValue() -> Int {
        switch self {
        case .TEXT:             return 1
        case .VOICE:            return 2
        case .PICTURE:          return 3
        case .VIDEO:            return 4
        case .SOUND:            return 5
        case .FILE:             return 6
        case .POD_SPACE_PICTURE: return 7
        case .POD_SPACE_VIDEO:  return 8
        case .POD_SPACE_SOUND:  return 9
        case .POD_SPACE_VOICE:  return 10
        case .POD_SPACE_FILE:   return 11
        case .LINK:             return 12
        }
    }
    
	@available(*,deprecated , message: "removed in future release.")
    public static func getType(from: Int) -> MessageType {
        switch from {
        case 1:     return MessageType.TEXT
        case 2:     return MessageType.VOICE
        case 3:     return MessageType.PICTURE
        case 4:     return MessageType.VIDEO
        case 5:     return MessageType.SOUND
        case 6:     return MessageType.FILE
        case 7:     return MessageType.POD_SPACE_PICTURE
        case 8:     return MessageType.POD_SPACE_VIDEO
        case 9:     return MessageType.POD_SPACE_SOUND
        case 10:    return MessageType.POD_SPACE_VOICE
        case 11:    return MessageType.POD_SPACE_FILE
        case 12:    return MessageType.LINK
        default:    return MessageType.TEXT
        }
    }
    
}

