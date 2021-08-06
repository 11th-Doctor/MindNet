//
//  SearchUserController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/31.
//

import UIKit

class UsersSearchController: BaseCollectionController<UsersSearchCell, User> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
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
        }
    }
    
    fileprivate func setupViews() {
        navigationItem.title = "搜尋"
    }
}

extension UsersSearchController: UsersSearchDelegate {
    
    func followUser(userId: String) {
        Service.shared.followUser(userId: userId) { result in
            switch result {
            case .failure(let err):
                print("Failed to follow user: ",err)
                break
            case.success(_):
                let index = self.items.firstIndex(where: { $0._id == userId })
                
                if let index = index {
                    let indexPath = IndexPath(item: index, section: 0)
                    let itemCell = self.collectionView.cellForItem(at: indexPath) as? UsersSearchCell
                    itemCell?.followButton.backgroundColor = .black
                    itemCell?.followButton.setTitle("取消追蹤", for: .normal)
                    itemCell?.followButton.setTitleColor(.white, for: .normal)
//                    self.collectionView.reloadItems(at: [indexPath])
                }
                
                break
            }
        }
    }
    
    func unfollowUser(userId: String) {
        print("userId to unfollow: \(userId)")
    }
}

extension UsersSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
