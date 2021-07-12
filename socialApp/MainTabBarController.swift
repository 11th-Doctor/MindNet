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
    
    func refreshPosts() {
        //TODO: refresh the profile
        homeController.fetchPosts()
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
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] {
            selectedImage = editedImage as? UIImage
        } else if let image = info[.originalImage] {
            selectedImage = image as? UIImage
        }
        
        if let selectedImage = selectedImage {
            
            picker.dismiss(animated: true) {
                let createPostController = CreatePostController(selectedImage: selectedImage)
                self.present(createPostController, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
