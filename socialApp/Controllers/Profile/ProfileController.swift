//
//  ProfileController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/17.
//

import UIKit

class ProfileController: BaseHeaderCollectionController<PostCell, Post, ProfileHeader> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
    }
    
    override func setupHeader(header: ProfileHeader) {
    }
    
    @objc func fetchPosts() {
        Service.shared.fetchPosts { result in
            switch result {
            case .failure(let err):
                print("Failed to fetch posts", err.localizedDescription)
                break
            case .success(let posts):
                print(posts)
                self.items = posts
                break
            }
        }
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = estimatedCellHeight(for: indexPath, cellWidth: width)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
}
