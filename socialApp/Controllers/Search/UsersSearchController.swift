//
//  SearchUserController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/31.
//

import UIKit
import JGProgressHUD

class UsersSearchController: BaseCollectionController<UsersSearchCell, User, UserViewModel> {
    
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
            case .success(let userViewModels):
                self.items = userViewModels
                self.collectionView.reloadData()
                break
            }
            
            hud.dismiss(animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        let profileController = ProfileController(userId: item.userIdToFollow)
        navigationController?.pushViewController(profileController, animated: true)
    }
    
    fileprivate func setupViews() {
        navigationItem.title = "搜尋"
    }
}

extension UsersSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
