//
//  SearchUserController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/31.
//

import UIKit
import JGProgressHUD

class UsersSearchController: BaseCollectionController<UsersSearchCell, User> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        Service.shared.searchForUsers { result in
            
            switch result {
            case .failure(let err):
                print("Failed to search users", err)
                break
            case .success(let users):
                self.items = users
                self.collectionView.reloadData()
                break
            }
            
            hud.dismiss(animated: true)
        }
    }
    
    fileprivate func setupViews() {
        navigationItem.title = "搜尋"
    }
}

extension UsersSearchController: UsersSearchDelegate {
    
    func didFollowUser(user: User) {
        let userId = user._id
        let isFollowing = user.isFollowing == true
        let url = "\(Service.shared.baseUrl)/user/\(isFollowing ? "unfollow" : "follow")/\(userId)"
        
        Service.shared.followUser(userId: userId, url: url) { result in
            switch result {
            case .failure(let err):
                print("Faied follow/unfollow the user ",err)
                break
            case.success(_):
                if let index = self.items.firstIndex(where: { $0._id == userId}) {
                    self.items[index].isFollowing = !isFollowing
                    let indexPath = IndexPath(item: index, section: 0)
                    self.collectionView.reloadItems(at: [indexPath])
                }
                break
            }
        }
    }
}

extension UsersSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
