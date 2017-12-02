//
//  CustomTabBarController.swift
//  messenger
//
//  Created by Mukesh Sharma on 02/12/17.
//  Copyright © 2017 Mukesh Sharma. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")
        
        let callController = createDummyNavController(title: "Calls", imageName: "calls")
        let peopleController = createDummyNavController(title: "People", imageName: "people")
        let groupsController = createDummyNavController(title: "Groups", imageName: "groups")
        let settingsController = createDummyNavController(title: "Settings", imageName: "settings")
        
        viewControllers = [recentMessagesNavController, callController, peopleController, groupsController, settingsController]
    }
    
    private func createDummyNavController(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}
