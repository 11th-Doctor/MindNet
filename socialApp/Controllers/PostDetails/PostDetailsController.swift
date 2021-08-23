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
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(fetchComments), for: .valueChanged)
        fetchComments()
    }
    
    @objc fileprivate func fetchComments() {
        Service.shared.fetchComments(postId: postId) { result in
            self.collectionView.refreshControl?.beginRefreshing()
            switch result {
            case .failure(let err):
                print("Failed to fetch comments: ", err)
                break
            case .success(let comments):
                self.items = comments.map({ return CommentViewModel(model: $0) })
                break
            }
            self.collectionView.refreshControl?.endRefreshing()
            let indexPath = IndexPath(item: self.items.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc fileprivate func handleSubmittion() {
        if let comment = customAccessoryView.textView.text, !comment.isEmpty {
            Service.shared.submitComment(postId: postId, comment: comment) { result in
                switch result {
                case .failure(let err):
                    print("Failed to submit the comment", err)
                    break
                case.success(_):
                    self.fetchComments()
                    break
                }
            }
        }
        
        customAccessoryView.textView.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostDetailsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = CommentCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let commentViewModel = items[indexPath.item]
        dummyCell.item = commentViewModel
        dummyCell.layoutIfNeeded()
        let height = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 50)).height
        
        return CGSize(width: view.frame.width, height: height)
    }
}
