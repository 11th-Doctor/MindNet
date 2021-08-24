//
//  PostViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/8.
//

import UIKit
import Combine

class PostViewModel: ViewModel<Post> {
    
    let id: String
    let profileImageUrl: String
    let fullName: String
    let fromNow: String
    let text: String
    let imageUrl: String
    var hasLiked: Bool
    @Published var likeButtonImage: UIImage
    @Published var numLikes: Int
    let canDelete: Bool
    
    private var subscribers: [AnyCancellable?] = []
    
    required init(model: Post) {
        id = model._id
        profileImageUrl = model.user.profileImageUrl ?? ""
        fullName = model.user.fullName
        fromNow = model.fromNow
        text = model.text
        imageUrl = model.imageUrl
        canDelete = model.canDelete
        hasLiked = model.hasLiked ?? false
        numLikes = model.numLikes
        
        if hasLiked {
            likeButtonImage = #imageLiteral(resourceName: "like-filled")
        } else {
            likeButtonImage = #imageLiteral(resourceName: "like-outline")
        }
        
        super.init(model: model)
        
    }
    
    func bindLikeButton(likeButton: UIButton) {
        subscribers.append($likeButtonImage
                            .receive(on: RunLoop.main)
                            .map({ self.hasLiked ? $0.withTintColor(.red) : $0.withRenderingMode(.alwaysOriginal)})
                            .sink(receiveValue: { likeButton.setImage($0, for: .normal) }))
    }
    
    func bindNumLikesButton(numLikesButton: UIButton) {
        subscribers.append($numLikes
                            .receive(on: RunLoop.main)
                            .map({ "\($0) 個喜歡"})
                            .sink(receiveValue: { numLikesButton.setTitle($0, for: .normal)}))
    }
    
    func showOptions(viewController: UIViewController) {
        let alertController = UIAlertController(title: "選單", message: nil, preferredStyle: .actionSheet)
        
        if canDelete {
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
        } else {
            print("cannot be deleted.")
        }
        
        alertController.addAction(.init(title: "取消", style: .cancel, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func handleLike() {
        Service.shared.likePost(postId: id, hasLiked: hasLiked) { result in
            switch result {
            case .failure(let err):
                print("Failed to like/dislile the post", err)
                break
            case .success(_):
                
                self.hasLiked = !self.hasLiked
                
                if self.hasLiked {
                    self.likeButtonImage = #imageLiteral(resourceName: "like-filled")
                    self.numLikes += 1
                } else {
                    self.likeButtonImage = #imageLiteral(resourceName: "like-outline")
                    self.numLikes -= 1
                }
                
                break
            }
        }
    }
    
    func fetchLikes(parentController: UIViewController) {
        let likesController = LikesController(postId: id)
        parentController.navigationController?.pushViewController(likesController, animated: true)
    }
}
