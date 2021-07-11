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
        delegate = self
        viewControllers = [
            createNavController(viewController: homeController, tabBarImage: #imageLiteral(resourceName: "home")),
            createNavController(viewController: UIViewController(), tabBarImage: #imageLiteral(resourceName: "plus")),
            createNavController(viewController: UIViewController(), tabBarImage: #imageLiteral(resourceName: "user"))
        ]
        tabBar.tintColor = .black
    }
    
    fileprivate func createNavController(viewController: UIViewController, tabBarImage: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = tabBarImage
        return navController
    }

}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewControllers?.firstIndex(of: viewController) == 1 {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            present(imagePickerController, animated: true, completion: nil)
            return false
        }
        return true
    }
}

extension MainTabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] {
            print(editedImage)
        } else if let image = info[.originalImage] {
            print(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
