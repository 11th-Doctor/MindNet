//
//  LikesController.swift
//  socialApp
//
//  Created by Daryl on 2021/8/24.
//

import UIKit

class LikesController: BaseCollectionController<LikeCell, User, LikeViewModel> {
    
    let postId: String
    
    init(postId: String) {
        self.postId = postId
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "喜歡"
        fetchLikes()
    }
    
    fileprivate func fetchLikes() {
        Service.shared.fetchLikes(postId: postId) { result in
            switch result {
            case .failure(let err):
                print("Failed to fetch likes", err)
                break
            case .success(let users):
                self.items = users.map({ return LikeViewModel(model: $0) })
                break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LikesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 76)
    }
}
