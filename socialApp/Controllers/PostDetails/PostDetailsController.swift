//
//  PostDetailsController.swift
//  socialApp
//
//  Created by Daryl on 2021/8/21.
//

import UIKit

class PostDetailsController: BaseCollectionController<CommentCell, Comment, CommentViewModel> {
    let postId: String
    
    lazy var customAccessoryView: CustomAccessoryView = {
        let view = CustomAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        view.submitButton.addTarget(self, action: #selector(handleSubmittion), for: .touchUpInside)
        return view
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return customAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    init(postId: String) {
        self.postId = postId
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "留言"
        collectionView.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true
    }
    
    @objc fileprivate func handleSubmittion() {
        if let comment = customAccessoryView.textView.text, !comment.isEmpty {
            Service.shared.submitComment(postId: postId, comment: comment) { result in
                switch result {
                case .failure(let err):
                    print("Failed to submit the comment", err)
                    break
                case.success(_):
                    break
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostDetailsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 60)
    }
}
