//
//  ProfileHeader.swift
//  socialApp
//
//  Created by Daryl on 2021/7/18.
//

import UIKit

class ProfileHeader: BaseReusableView<User, UserHeaderViewModel> {
    
    lazy var profileImageView: CircularImageView = {
        let view = CircularImageView(width: 80)
        view.image = #imageLiteral(resourceName: "user")
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditProfile)))
        return view
    }()
    
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("追蹤", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(followUser), for: .touchUpInside)
        return button
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("編輯檔案", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(red: 0.2392156860, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    let postsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.text = "貼文數"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    let followersCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "追蹤數"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    let followingCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "追蹤中"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "Here's an interesting piece of bio that will definately capture your attention and all the fans around the world."
        return label
    }()
    
    override var item: UserHeaderViewModel! {
        didSet {
            fullNameLabel.text = item.fullName
            bioLabel.text = item.bio
            profileImageView.sd_setImage(with: item.profileImageUrl)
            followingCountLabel.text = "\(item.following)"
            followersCountLabel.text = "\(item.followers)"
            postsCountLabel.text = "\(item.posts)"
            item.bindFollowEditButtons(followButton: followButton, editProfileButton: editProfileButton)
        }
    }
    
    weak var profileController: ProfileController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @objc fileprivate func handleEditProfile() {
        profileController?.selectProfile()
    }
    
    @objc func editProfile() {
        let editProfileController = EditProfileController(viewModel: item)
        let navController = UINavigationController(rootViewController: editProfileController)
        profileController?.present(navController, animated: true)
    }
    
    @objc func followUser() {
        item.didFollowUser()
    }
    
    func setupViews() {
        addSubview(profileImageView)
        addSubview(followButton)
        addSubview(editProfileButton)
        addSubview(fullNameLabel)
        addSubview(bioLabel)
        
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        followButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 28)
        followButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        editProfileButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 28)
        editProfileButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let countsStack = UIStackView(arrangedSubviews: [
            countsVerticalStack(titleLabel: postsCountLabel, coutsLabel: postsLabel),
            countsVerticalStack(titleLabel: followersCountLabel, coutsLabel: followersLabel),
            countsVerticalStack(titleLabel: followingCountLabel, coutsLabel: followingLabel),
        ])
        countsStack.axis = .horizontal
        countsStack.distribution = .fillEqually
        countsStack.spacing = 16
        
        addSubview(countsStack)
        countsStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 52, paddingLeft: 14, paddingBottom: 0, paddingRight: 14, width: 0, height: 28)
        
        fullNameLabel.anchor(top: countsStack.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 14, paddingBottom: 0, paddingRight: 14, width: 0, height: 14)
        
        bioLabel.anchor(top: fullNameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 14, paddingLeft: 14, paddingBottom: 14, paddingRight: 14, width: 0, height: 0)
    
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        addSubview(seperatorView)
        
        seperatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    fileprivate func countsVerticalStack(titleLabel title: UILabel, coutsLabel counts: UILabel) -> UIStackView {
        let view = UIStackView(arrangedSubviews: [title,counts])
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("No Retain cylce/Leak for ProfileHeader")
    }
}
