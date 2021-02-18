//
//  DevicesResposne.swift
//  FanapPodChatSDK
//
//  Created by Hamed Hosseini on 2/17/21.
//

import Foundation
class DevicesResposne : Codable{
	let devices: [Device]?
	let offset : Int?
	let size   : Int?
	let total  : Int?
}
