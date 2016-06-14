//
//  ContactsTableViewController.swift
//  AlzYouNeed
//
//  Created by Connor Wybranowski on 6/13/16.
//  Copyright © 2016 Alz You Need. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactsTableViewController: UITableViewController, CNContactPickerDelegate {
    
//    var userContacts: [CNContact] = []
    
    var userContacts: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContactsTableViewController.insertNewObject(_:)), name: "addNewContact", object: nil)
        
        getContacts()
        
        addNewGroup()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Logic
    
    func getContacts() {
        let store = CNContactStore()
        
        // Check if use of contacts is authorized
        if CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined {
            store.requestAccessForEntityType(.Contacts, completionHandler: { (authorized: Bool, error: NSError?) in
                if authorized {
                    self.retrieveContactsWithStore(store)
                }
            })
        }
        // Immediately retrieve contacts
        else if CNContactStore.authorizationStatusForEntityType(.Contacts) == .Authorized {
            self.retrieveContactsWithStore(store)
        }
    }
    
    func retrieveContactsWithStore(store: CNContactStore) {
        do {
            // Predicate matches all groups
            let groups = try store.groupsMatchingPredicate(nil)
            let predicate = CNContact.predicateForContactsInGroupWithIdentifier(groups[0].identifier)
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactEmailAddressesKey, CNContactPhoneNumbersKey]
            
            let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
            
            for contact in contacts {
//                let person
            }
            
            self.userContacts = contacts
            
//            print("First contact:")
//            print("Phone number: \(contacts[0].phoneNumbers[0].value)")
            
            // Update tableview on main thread
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
            })
        }
        catch {
            print(error)
        }
    }
    
    func addExistingContact() {
        let contactPicker = CNContactPickerViewController()
        
//        contactPicker.predicateForSelectionOfContact = NSPredicate(format: "", argumentArray: nil)
        
        contactPicker.delegate = self
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    @IBAction func addExisting(sender: AnyObject) {
        addExistingContact()
    }
    
    func addNewGroup() {
        if !checkExistingGroups("Family - Alz You Need") {
            print("Creating Family group")
        
            let store = CNContactStore()
            
            let familyGroup = CNMutableGroup()
            familyGroup.name = "Family - Alz You Need"
            let saveRequest = CNSaveRequest()
            saveRequest.addGroup(familyGroup, toContainerWithIdentifier: nil)
            
            do {
                try store.executeSaveRequest(saveRequest)
                print("Adding new group")
            }
            catch {
                print(error)
            }
        }
        else {
            print("Family group exists")
        }
    }
    
    func checkExistingGroups(group: String) -> Bool {
        do {
            let store = CNContactStore()
            let groups = try store.groupsMatchingPredicate(nil)
            let filteredGroups = groups.filter {
                $0.name == "\(group)"
            }
            
            guard let checkedGroup = filteredGroups.first else {
                print("No \(group) group")
                return false
            }
            
            let predicate = CNContact.predicateForContactsInGroupWithIdentifier(checkedGroup.identifier)
            let keysToFetch = [CNContactGivenNameKey]
            let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
            
            print(contacts)
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    func saveContactInGroup(contact: CNContact) {
        let store = CNContactStore()
        print(contact.phoneNumbers[0].value)
        
        // Create copy of contact to update
        var newContact = contact.mutableCopy() as! CNMutableContact
        
    }
    
    // MARK: - CNContactPickerDelegate
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        NSNotificationCenter.defaultCenter().postNotificationName("addNewContact", object: nil, userInfo: ["contactToAdd": contact])
    }
    
    func insertNewObject(sender: NSNotification) {
        if let contact = sender.userInfo?["contactToAdd"] as? CNContact {
            userContacts.insert(contact, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userContacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath)

        let contact = userContacts[indexPath.row]
        let formatter = CNContactFormatter()
        
        cell.textLabel?.text = formatter.stringFromContact(contact)
        cell.detailTextLabel?.text = contact.emailAddresses.first?.value as? String
//        for phoneNumber in contact.phoneNumbers {
//            let number = (phoneNumber.value as! CNPhoneNumber).stringValue
//            print(number)
//        }
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contactObject = userContacts[indexPath.row]
                let controller = segue.destinationViewController as! ContactDetailViewController
                controller.contactItem = contactObject
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    

}
