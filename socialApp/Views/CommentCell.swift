//
//  CommentCell.swift
//  socialApp
//
//  Created by Daryl on 2021/8/21.
//

import UIKit

class CommentCell: BaseCollectionCell<Comment, CommentViewModel> {
    
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
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let fromNowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        
        return label
    }()
    
    override var item: CommentViewModel! {
        didSet {
            profileImageView.sd_setImage(with: item.profileImageUrl)
            usernameLabel.text = item.fullName
            commentLabel.text = item.text
            fromNowLabel.text = item.fromNow
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(commentLabel)
        addSubview(fromNowLabel)
        addSubview(separatorView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)

        commentLabel.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: fromNowLabel.topAnchor, right: usernameLabel.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)

        fromNowLabel.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: usernameLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 0)
        
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
