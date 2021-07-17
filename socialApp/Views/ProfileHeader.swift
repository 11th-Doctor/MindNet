//
//  ProfileHeader.swift
//  socialApp
//
//  Created by Daryl on 2021/7/18.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    var user: User! {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
