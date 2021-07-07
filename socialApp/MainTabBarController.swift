//
//  MainTabBarController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/7.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var homeController = HomeController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: homeController, tabBarImage: #imageLiteral(resourceName: "home"))
        ]
        tabBar.tintColor = .black
    }
    
    fileprivate func createNavController(viewController: UIViewController, tabBarImage: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = tabBarImage
        return navController
    }
}
