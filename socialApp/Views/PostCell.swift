//
//  PostCell.swift
//  socialApp
//
//  Created by Daryl on 2021/7/13.
//

import UIKit
import SDWebImage

class PostCell: BaseCollectionCell<Post, PostViewModel> {
    
    lazy var profileImageView: CircularImageView = {
        let view = CircularImageView(width: 44, image: nil)
        view.layer.borderWidth = 0.5
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImage)))
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
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
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
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleNumLikes), for: .touchUpInside)
        return button
    }()
    
    let blurVisualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    let termsLabel: UILabel = {
        let label = UILabel()
        let invisibleAttributedAttachment = NSTextAttachment(image: #imageLiteral(resourceName: "invisible").withTintColor(.white))
        invisibleAttributedAttachment.bounds = CGRect(x: 0, y: 30, width: 40, height: 40)
        let invisibleAttributedString = NSMutableAttributedString(attachment: invisibleAttributedAttachment)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        paragraphStyle.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: "\n敏感內容\n", attributes: [.foregroundColor : UIColor.white, .font : UIFont.systemFont(ofSize: 16, weight: .bold), .paragraphStyle : paragraphStyle])
        attributedString.append(NSAttributedString(string: "該則貼文包含了敏感內容，可能讓部份人士感到冒犯或反感。", attributes: [.foregroundColor : UIColor.white, .font : UIFont.systemFont(ofSize: 14)]))
        
        invisibleAttributedString.append(attributedString)
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = invisibleAttributedString
        return label
    }()
    
    lazy var seePostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("觀看內容", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSeeContent), for: .touchUpInside)
        return button
    }()
    
    override var item: PostViewModel! {
        didSet {
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
            fromNowLabel.text = item.fromNow
            usernameLabel.text = item.fullName
            postImageView.sd_setImage(with: URL(string: item.imageUrl))
            textBodyLabel.text = item.text
            
            item.bindLikeButton(likeButton: likeButton)
            item.bindNumLikesButton(numLikesButton: numLikesButton)
            item.bindPostCell(postcell: self)
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
    
    @objc fileprivate func handleProfileImage() {
        let profileController = ProfileController(userId: item.model.user._id)
        parentController?.navigationController?.pushViewController(profileController, animated: true)
    }
    
    @objc fileprivate func showOptions() {
        if let viewController = parentController {
            item.showOptions(viewController: viewController)
        }
    }
    
    @objc func handleLike() {
        item.handleLike()
    }
    
    @objc fileprivate func handleNumLikes() {
        if let parentController = parentController {
            item.fetchLikes(parentController: parentController)
        }
    }
    
    @objc func handleComment() {
        let postDetailsController = PostDetailsController(postId: item.id)
        postDetailsController.hidesBottomBarWhenPushed = true
        parentController?.navigationController?.pushViewController(postDetailsController, animated: true)
    }
    
    @objc fileprivate func handleSeeContent() {
        item.showSensitiveContent()
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
    
    func setupVisualEffectBlur() {
        addSubview(blurVisualEffectView)
        blurVisualEffectView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        
        blurVisualEffectView.contentView.addSubview(separatorView)
        blurVisualEffectView.contentView.addSubview(seePostButton)
        blurVisualEffectView.contentView.addSubview(termsLabel)
        
        separatorView.anchor(top: nil, left: blurVisualEffectView.leftAnchor, bottom: seePostButton.topAnchor, right: blurVisualEffectView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0.5)
        
        seePostButton.anchor(top: nil, left: blurVisualEffectView.leftAnchor, bottom: blurVisualEffectView.bottomAnchor, right: blurVisualEffectView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 0, height: 50)
        
        termsLabel.anchor(top: nil, left: blurVisualEffectView.leftAnchor, bottom: nil, right: blurVisualEffectView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        termsLabel.centerYAnchor.constraint(equalTo: blurVisualEffectView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
