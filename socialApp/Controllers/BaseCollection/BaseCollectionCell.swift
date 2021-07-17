//
//  BaseCollectionCell.swift
//  socialApp
//
//  Created by Daryl on 2021/7/13.
//

import UIKit

class BaseCollectionCell<T: Codable>: UICollectionViewCell {
    
    var item: T!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
