//
//  PhoneContact+CoreDataClass.swift
//  FanapPodChatSDK
//
//  Created by Mahyar Zhiani on 11/23/1397 AP.
//  Copyright © 1397 Mahyar Zhiani. All rights reserved.
//
//

import Foundation
import CoreData


//only use to fill data when query on user Device contact
struct PhoneContactModel {
    var cellphoneNumber : String?
    var email           : String?
    var firstName       : String?
    var lastName        : String?
    
    
    func convertToAddRequest()->AddContactRequest{
        return AddContactRequest(cellphoneNumber: cellphoneNumber,
                                 email: email,
                                 firstName: firstName,
                                 lastName: lastName)
    }
    
}

public class PhoneContact: NSManagedObject {
    
    static let crud = CoreDataCrud<PhoneContact>(entityName: "PhoneContact")
    
    func updateObject(with contact: AddContactRequest) {
        self.cellphoneNumber    = contact.cellphoneNumber
        self.email              = contact.email
        self.firstName          = contact.firstName
        self.lastName           = contact.lastName
    }
    
    func convertToContact()->Contact{
        return Contact(cellphoneNumber:  cellphoneNumber,
                       email:            email,
                       firstName:        firstName,
                       hasUser:          false,
                       lastName:         lastName)
    }
    
    class func isContactChanged(_ cacheContact:Contact , phoneContactModel:PhoneContactModel)->Bool{
        return (cacheContact.email != phoneContactModel.email) ||
            (cacheContact.firstName != phoneContactModel.firstName) ||
            (cacheContact.lastName != phoneContactModel.lastName)
    }
    
    // MARK: - save PhoneBook Contact:
    /// Save PhoneBook Contact:
    /// by calling this function, it save (or update) PhoneContact that comes from users phone, into the Cache.
    ///
    /// - fetch PhoneContact objects from 'PhoneContact' Entity
    /// - filter it by cellphoneNumber
    /// - if it found any PhoneContact object, it will update its values on the Cache
    /// - otherwise it will create new CMContact
    ///
    /// Inputs:
    /// it gets  "AddContactRequestModel" model as an input
    ///
    /// Outputs:
    /// it returns no output
    ///
    /// - parameters:
    ///     -  contact:     contacts to save on Cache. (AddContactRequestModel)
    ///
    /// - Returns:
    ///     none
    ///
    public class func savePhoneBookContact(contact : AddContactRequest) {
        
        if let contactCellphoneNumber = contact.cellphoneNumber {
            if let findedContact = PhoneContact.crud.find(keyWithFromat: "cellphoneNumber == %@", value: contactCellphoneNumber){
                //update CoreData Model ,this is the coreData Model not need to be fetched from CoreData and after save all changes saved.
                findedContact.firstName = contact.firstName
                findedContact.lastName  = contact.lastName
                findedContact.email     = contact.email
                PSM.shared.save()
            }else{
                //insert CoreData Model
                PhoneContact.crud.insert { phoneContactEntity in
                    phoneContactEntity.cellphoneNumber = contact.cellphoneNumber
                    phoneContactEntity.email           = contact.email
                    phoneContactEntity.firstName       = contact.firstName
                    phoneContactEntity.lastName        = contact.lastName
                }
            }
        }
    }
    
    public class func updateOrInsertPhoneBooks(contacts : [AddContactRequest]) {
        for contact in contacts {
            PhoneContact.savePhoneBookContact(contact: contact)
        }
    }
    
}
