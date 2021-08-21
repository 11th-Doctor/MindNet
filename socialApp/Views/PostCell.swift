//
//  PostCell.swift
//  socialApp
//
//  Created by Daryl on 2021/7/13.
//

import UIKit
import SDWebImage

class PostCell: BaseCollectionCell<Post, PostViewModel> {
    
    let profileImageView: CircularImageView = {
        let view = CircularImageView(width: 44, image: nil)
        view.layer.borderWidth = 0.5
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 15)
    
        return label
    }()
    
    let fromNowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "post_options"), for: .normal)
        return button
    }()
    
    let postImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let textBodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "like-outline"), for: .normal)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "comment-bubble"), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    lazy var numLikesButton: UIButton = {
        let button = UIButton()
        button.setTitle("0 個喜歡", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
    override var item: PostViewModel! {
        didSet {
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
            fromNowLabel.text = item.fromNow
            usernameLabel.text = item.fullName
            postImageView.sd_setImage(with: URL(string: item.imageUrl))
            textBodyLabel.text = item.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageHeightAnchor.constant = frame.width
    }
    
    @objc func showOptions() {
        if let viewController = parentController {
            item.showOptions(viewController: viewController)
        }
    }
    
    @objc func handleComment() {
        let postDetailsController = PostDetailsController(postId: item.id)
        postDetailsController.hidesBottomBarWhenPushed = true
        parentController?.navigationController?.pushViewController(postDetailsController, animated: true)
    }
    
    var imageHeightAnchor: NSLayoutConstraint!
    
    fileprivate func setupViews() {
        
        addSubview(profileImageView)
        addSubview(optionsButton)
        addSubview(fromNowLabel)
        addSubview(usernameLabel)
        addSubview(postImageView)
        addSubview(textBodyLabel)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(numLikesButton)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: usernameLabel.leftAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        optionsButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 34, height: 34)
        optionsButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: profileImageView.topAnchor, left: nil, bottom: nil, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        fromNowLabel.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: profileImageView.bottomAnchor, right: usernameLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        imageHeightAnchor = postImageView.heightAnchor.constraint(equalToConstant:  0)
        imageHeightAnchor.isActive = true

        textBodyLabel.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: likeButton.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 12, paddingRight: 16, width: 0, height: 0)
        
        likeButton.anchor(top: nil, left: textBodyLabel.leftAnchor, bottom: numLikesButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 34, height: 34)
        
        commentButton.anchor(top: nil, left: likeButton.rightAnchor, bottom: numLikesButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 12, paddingRight: 0, width: 34, height: 34)
        
        numLikesButton.anchor(top: nil, left: textBodyLabel.leftAnchor, bottom: bottomAnchor, right: commentButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 34)
        
        addSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
