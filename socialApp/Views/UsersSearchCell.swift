//
//  UsersSearchCell.swift
//  socialApp
//
//  Created by Daryl on 2021/7/31.
//

import UIKit
import Combine

class UsersSearchCell: BaseCollectionCell<User, UserViewModel> {
    
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
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
       
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(followUser), for: .touchUpInside)
        button.layer.cornerRadius = 17
        return button
    }()
    
    override var item: UserViewModel! {
        didSet {
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
            usernameLabel.text = item.fullName
            item.bindFollowButton(followButton: followButton)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @objc fileprivate func followUser() {
        item.didFollowUser()
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(followButton)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: followButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        followButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 100, height: 34)
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSeparatorView(leadingContraint: profileImageView.rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
