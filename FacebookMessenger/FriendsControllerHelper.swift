//
//  FriendsControllerHelper.swift
//  FacebookMessenger
//
//  Created by Ellen Mey on 10/12/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            do {
                let entityNames = ["Friend", "Message"]
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest(entityName: entityName)
                    let objects = try(context.executeFetchRequest(fetchRequest)) as? [NSManagedObject]
                    for object in objects! {
                        context.deleteObject(object)
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
            
        }
    }
    
    func setupData() {
        clearData()
        
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            let ellen = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            ellen.name = "Ellen Mey"
            ellen.profileImageName = "ellen"
            
            let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
            message.friend = ellen
            message.text = "Hello, my name is Ellen. Nice to meet you..."
            message.date = NSDate()
            
            let bob = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            bob.name = "Fry"
            bob.profileImageName = "not_sure"
            createMessageWithText("Good morning", friend: bob, minutesAgo: 3, context: context)
            createMessageWithText("How are you today? I hope you are having a wonderful day.", friend: bob, minutesAgo:2, context: context)
            createMessageWithText("Do you want to go to the zoo? I think my friends are going to see the monkeys. I love monkeys, don't you? They are just so funny!", friend: bob, minutesAgo: 1, context: context)
            
            createSteveMessagesWithContext(context)

            let mark = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "zuckprofile"
            createMessageWithText("I am going to save all of the panda bears!", friend: mark, minutesAgo: 60 * 24 * 8, context: context)
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        loadData()
    }
    
    private func createSteveMessagesWithContext(context: NSManagedObjectContext) {
        let steve = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        createMessageWithText("I hear the new samsung phone is lit. Hahaha I crack myself up!", friend: steve, minutesAgo: 60 * 24, context: context)
        createMessageWithText("Hey buddy!", friend: steve, minutesAgo: 3, context: context)
        createMessageWithText("How are you today? I hope you are having a wonderful day. Let's get lunch soon in the courtyard by the duckies!", friend: steve, minutesAgo:2, context: context)
        createMessageWithText("I'm fantastic. I can't wait to go to the rock and roll show", friend: steve, minutesAgo: 1, context: context, isSender: true)
        createMessageWithText("How's Wednesday for lunch?", friend: steve, minutesAgo: 1, context: context, isSender: true)
        createMessageWithText("Perfect! Can't wait to watch the little duckies in the pond. Quack quack!", friend: steve, minutesAgo: 1, context: context)
        createMessageWithText("Awesome. Let's have tacos!", friend: steve, minutesAgo: 1, context: context, isSender: true)
        createMessageWithText("Tacos are the best! I once went to Tijuana with John and ate tacos for an entire week. That was the best week of my life. I should schedule another trip like that soon. Time for more tacos!", friend: steve, minutesAgo: 1, context: context)
        
        
    }
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().dateByAddingTimeInterval(-minutesAgo * 60)
        message.isSender = NSNumber(bool: isSender)
    }
    
    func loadData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            messages = [Message]()
            
            if let friends = fetchFriends() {
                for friend in friends {
                    print(friend.name)
                    let fetchRequest = NSFetchRequest(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    
                    do {
                        let fetchedMessages = try(context.executeFetchRequest(fetchRequest)) as? [Message]
                        messages?.appendContentsOf(fetchedMessages!)
                    } catch let err {
                        print(err)
                    }
                }
                
                messages = messages?.sort({$0.date!.compare($1.date!) == .OrderedDescending})
            }
        }
    }
    private func fetchFriends() -> [Friend]? {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if let context = delegate?.managedObjectContext {
            let request = NSFetchRequest(entityName: "Friend")
            do {
                return try context.executeFetchRequest(request) as? [Friend]
            } catch let err {
                print(err)
            }
        }
        return nil
    }
    
}
