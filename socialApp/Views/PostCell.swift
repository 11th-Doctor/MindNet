//
//  PostCell.swift
//  socialApp
//
//  Created by Daryl on 2021/7/13.
//

import UIKit
import SDWebImage

class PostCell: BaseCollectionCell<Post> {
    
    let profileImageView: CircularImageView = {
        let view = CircularImageView(width: 44, image: nil)
        
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
        label.text = "Posted five days ago"
        label.textColor = .gray
        
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        let buttonn = UIButton()
        buttonn.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        return buttonn
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
    
    override var item: Post! {
        didSet {
            usernameLabel.text = item.user.fullName
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
        
    }
    
    var imageHeightAnchor: NSLayoutConstraint!
    
    fileprivate func setupViews() {
        
        addSubview(profileImageView)
        addSubview(optionsButton)
        addSubview(fromNowLabel)
        addSubview(usernameLabel)
        addSubview(postImageView)
        addSubview(textBodyLabel)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: usernameLabel.leftAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        usernameLabel.anchor(top: profileImageView.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        fromNowLabel.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: profileImageView.bottomAnchor, right: usernameLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        imageHeightAnchor = postImageView.heightAnchor.constraint(equalToConstant:  0)
        imageHeightAnchor.isActive = true

        textBodyLabel.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
