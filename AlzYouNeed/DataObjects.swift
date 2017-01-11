//
//  DataObjects.swift
//  AlzYouNeed
//
//  Created by Connor Wybranowski on 1/11/17.
//  Copyright © 2017 Alz You Need. All rights reserved.
//

import Foundation
import UIKit

// A collection of all data objects
struct Contact {
    var userId: String!
    var fullName: String!
    var email: String!
    var phoneNumber: String!
    var photoUrl: String!
    var patient: String!
    var admin: String!
    var relation: String?
    
    var photo: UIImage?
    
    init?(userId: String, userDict: NSDictionary) {
        self.userId = userId
        
        guard let fullName = userDict.value(forKey: "name") as? String else {return nil}
        self.fullName = fullName
        
        guard let email = userDict.value(forKey: "email") as? String else {return nil}
        self.email = email
        
        guard let phoneNumber = userDict.value(forKey: "phoneNumber") as? String else {return nil}
        self.phoneNumber = phoneNumber
        
        guard let patient = userDict.value(forKey: "patient") as? String else {return nil}
        self.patient = patient
        
        self.admin = userDict.value(forKey: "admin") as? String ?? "false"
        self.photoUrl = userDict.value(forKey: "photoUrl") as? String ?? ""
        self.relation = userDict.value(forKey: "relation") as? String ?? nil
    }
}

struct Message {
    var messageId: String!
    var senderId: String!
    var dateSent: String!
    var messageString: String!
//    var favorited: [String:String]!
    
    init?(messageId: String, messageDict: NSDictionary) {
        self.messageId = messageId
        
        guard let senderId = messageDict.object(forKey: "senderId") as? String else {return nil}
        self.senderId = senderId
        
        guard let dateSent = messageDict.object(forKey: "timestamp") as? String else {return nil}
        self.dateSent = dateSent
        
        guard let messageString = messageDict.object(forKey: "messageString") as? String else {return nil}
        self.messageString = messageString
        
//        self.favorited = messageDict.object(forKey: "favorited") as? [String:String] ?? [:]
    }
}

struct Reminder {
    var id: String!
    var title: String!
    var reminderDescription: String!
    var createdDate: String!
    var dueDate: String!
    var completedDate: String!
    var repeats: String!
    
    init?(reminderId: String, reminderDict: NSDictionary) {
        self.id = reminderId
        
        guard let title = reminderDict.value(forKey: "title") as? String else {return nil}
        self.title = title
        
        guard let reminderDescription = reminderDict.value(forKey: "description") as? String else {return nil}
        self.reminderDescription = reminderDescription
        
        guard let createdDate = reminderDict.value(forKey: "createdDate") as? String else {return nil}
        self.createdDate = createdDate
        
        guard let dueDate = reminderDict.value(forKey: "dueDate") as? String else {return nil}
        self.dueDate = dueDate
        
        guard let repeats = reminderDict.value(forKey: "repeats") as? String else {return nil}
        self.repeats = repeats
        
        self.completedDate = reminderDict.value(forKey: "completedDate") as? String ?? ""
    }
    
    func asDict() -> Dictionary<String, String> {
        let reminderDict: Dictionary<String, String> = ["title": self.title, "description": self.reminderDescription, "createdDate": self.createdDate, "dueDate": self.dueDate, "completedDate": self.completedDate, "repeats": self.repeats]
        return reminderDict
    }
}
