//
//  PostViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/8.
//

import UIKit

class PostViewModel: ViewModel<Post> {
    
    let id: String
    let profileImageUrl: String
    let fullName: String
    let fromNow: String
    let text: String
    let imageUrl: String
    
    required init(model: Post) {
        id = model._id
        profileImageUrl = model.user.profileImageUrl ?? ""
        fullName = model.user.fullName
        fromNow = model.fromNow
        text = model.text
        imageUrl = model.imageUrl
        super.init(model: model)
    }
    
    func showOptions(viewController: UIViewController) {
        let alertController = UIAlertController(title: "選單", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "刪除貼文", style: .destructive) { _ in
            Service.shared.deletePost(postId: self.id) { result in
                switch result {
                case .failure(let err):
                    print(err)
                    break
                case .success(_):
                    if let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController {
                        mainTabBarController.refreshPosts()
                    }
                }
            }
        })
        
        alertController.addAction(.init(title: "取消", style: .cancel, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
