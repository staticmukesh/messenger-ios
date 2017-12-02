//
//  FriendsControllerHelper.swift
//  messenger
//
//  Created by Mukesh Sharma on 02/12/17.
//  Copyright © 2017 Mukesh Sharma. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {
    func setUpData() {
        clearData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "zuckprofile"

        let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        donald.name = "Donald T rump"
        donald.profileImageName = "donaldprofile"
        
        FriendsController.createMessage(text: "I am CEO, bitch", friend: mark, minutesAgo: 60 * 24 * 12, context: context)
        FriendsController.createMessage(text: "You are fired", friend: donald, minutesAgo: 60 * 24, context: context)
        
        createSteveMessages(context: context)
        
        do {
            try(context.save())
        } catch let err {
            print(err)
        }
        
        loadData()
    }
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let friends = fetchFriends(context: context)
        messages = [Message]()
        
        for friend in friends {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "friend.name == %@", friend.name!)
            fetchRequest.fetchLimit = 1
            do {
                let friendsMsgs = try (context.fetch(fetchRequest)) as? [Message]
                messages?.append(contentsOf: friendsMsgs!)
            } catch let err {
                print(err)
            }
        }
        
        messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
    }
    
    func clearData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchFriendsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        let fetchMessagesRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        
        do {
            let friends = try (context.fetch(fetchFriendsRequest)) as? [Friend]
            let messages = try (context.fetch(fetchMessagesRequest)) as? [Message]
        
            for friend in friends! {
                context.delete(friend)
            }
            
            for message in messages!  {
                context.delete(message)
            }
            
            try(context.save())
        } catch let error {
            print(error)
        }
    }
    
    static func createMessage(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = Date().addingTimeInterval(-minutesAgo*60)
        message.isSender = isSender
        
        return message
    }
    
    func fetchFriends(context: NSManagedObjectContext) -> [Friend] {
        var friends = [Friend]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        do {
            friends = try (context.fetch(fetchRequest)) as! [Friend]
        } catch let error {
            print(error)
        }
        
        return friends
    }
    
    func createSteveMessages(context: NSManagedObjectContext) {
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steveprofile"
        
        FriendsController.createMessage(text: "Good morning", friend: steve, minutesAgo: 2, context: context)
        FriendsController.createMessage(text: "Hello, how are you, my friend? ", friend: steve, minutesAgo: 1, context: context)
        FriendsController.createMessage(text: "I am good. Do you want to buy any Apple product ? We have wide variety of products from which you can choose?", friend: steve, minutesAgo: 0, context: context)
        
        FriendsController.createMessage(text: "Yes, totally loooking for it.", friend: steve, minutesAgo: 0, context: context, isSender: true)
    }
}






