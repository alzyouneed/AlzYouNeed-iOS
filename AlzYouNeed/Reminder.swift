//
//  Reminder.swift
//  AlzYouNeed
//
//  Created by Connor Wybranowski on 7/9/16.
//  Copyright © 2016 Alz You Need. All rights reserved.
//

import UIKit

class Reminder: NSObject {

    var id: String!
    var title: String!
    var reminderDescription: String!
    var createdDate: String!
    var dueDate: String!
    var completedDate: String!
    var repeats: String!
    
    init(reminderId: String, reminderTitle: String, reminderDescription: String, reminderDueDate: String) {
        super.init()
        self.id = reminderId
        self.title = reminderTitle
        self.reminderDescription = reminderDescription
        self.dueDate = reminderDueDate
    }
    
    init?(reminderId: String, reminderDict: NSDictionary) {
        super.init()
        self.id = reminderId
        self.title = reminderDict.valueForKey("title") as! String
        self.reminderDescription = reminderDict.valueForKey("description") as! String
        self.createdDate = reminderDict.valueForKey("createdDate") as! String
        self.dueDate = reminderDict.valueForKey("dueDate") as! String
        self.completedDate = reminderDict.valueForKey("completedDate") as? String ?? ""
        self.repeats = reminderDict.valueForKey("repeats") as? String ?? "None"
    }
    
    override var description: String {
        return "id: \(id) -- title: \(title) -- description: \(reminderDescription) -- createdDate: \(createdDate) -- dueDate: \(dueDate) -- completedDate: \(completedDate) -- repeats: \(repeats)"
    }
    
    func asDict() -> NSDictionary {
        let reminderDict = ["title": self.title, "description": self.reminderDescription, "createdDate": self.createdDate, "dueDate": self.dueDate, "completedDate": self.completedDate, "repeats": self.repeats]
        return reminderDict
    }
    
}
