//
//  PostCell.swift
//  socialApp
//
//  Created by Daryl on 2021/7/13.
//

import UIKit
import SDWebImage

class PostCell: BaseCollectionCell<Post> {
    
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
            postImageView.sd_setImage(with: URL(string: item.imageUrl))
            textBodyLabel.text = item.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageHeightAnchor.constant = frame.width
    }
    
    var imageHeightAnchor: NSLayoutConstraint!
    
    fileprivate func setupViews() {
        
        addSubview(postImageView)
        addSubview(textBodyLabel)
        
        imageHeightAnchor = postImageView.heightAnchor.constraint(equalToConstant: 0)
        imageHeightAnchor.isActive = true
        
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
//        textBodyLabel.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
