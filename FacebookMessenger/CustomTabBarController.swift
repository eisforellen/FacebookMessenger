//
//  CustomTabBarController.swift
//  FacebookMessenger
//
//  Created by Ellen Mey on 10/12/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")
    
        
        viewControllers = [recentMessagesNavController, createDummyNavControllerWithTitle("Calls", imageName: "calls"), createDummyNavControllerWithTitle("Groups", imageName: "groups"),createDummyNavControllerWithTitle("People", imageName: "people"), createDummyNavControllerWithTitle("Settings", imageName: "settings") ]
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
