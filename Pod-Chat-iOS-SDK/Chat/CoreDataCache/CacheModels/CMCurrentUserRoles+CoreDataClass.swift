//
//  CMCurrentUserRoles+CoreDataClass.swift
//  FanapPodChatSDK
//
//  Created by MahyarZhiani on 1/9/1399 AP.
//  Copyright © 1399 Mahyar Zhiani. All rights reserved.
//
//

import Foundation
import CoreData


public class CMCurrentUserRoles: NSManagedObject {
    
    func updateObject(with roles: [Roles], onThreadId threadId: Int) {
        self.threadId   = threadId as NSNumber?
        self.roles      = RolesArray(roles: roles)
    }
    
}


public class RolesArray: NSObject, NSCoding {
    
    public var roles: [String] = []
    
    enum Key:String {
        case roles = "roles"
    }
    
    init(roles: [String]) {
        self.roles = roles
    }
    
    init(roles: [Roles]) {
        var myRoles: [String] = []
        for role in roles {
            myRoles.append(role.stringValue())
        }
        self.roles = myRoles
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(roles, forKey: Key.roles.rawValue)
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        let myRoles = aDecoder.decodeObject(forKey: Key.roles.rawValue) as! [String]
        self.init(roles: myRoles)
//        if let myRoles = aDecoder.decodeObject(forKey: Key.roles.rawValue) as? [String] {
//            self.init(roles: myRoles)
//        } else if let myRoles = aDecoder.decodeObject(forKey: Key.roles.rawValue) as? [Roles] {
//            self.init(roles: myRoles)
//        }
    }
    
}
