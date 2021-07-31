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

extension UsersSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
