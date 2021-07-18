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
        navigationItem.title = "個人資料"
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
        let header = ProfileHeader()
        let largeHeight: CGFloat = 250
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: largeHeight)
        header.layoutIfNeeded()
        let optimalSize = header.systemLayoutSizeFitting(.init(width: view.frame.width, height: largeHeight))
        print("optimalSize: \(optimalSize.height)")
        return optimalSize
    }
}
