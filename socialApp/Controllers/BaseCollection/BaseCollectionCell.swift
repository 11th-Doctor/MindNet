//
//  BaseCollectionCell.swift
//  socialApp
//
//  Created by Daryl on 2021/7/13.
//

import UIKit

class BaseCollectionCell<T: Decodable>: UICollectionViewCell {
    
    var item: T!
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.6, alpha: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    func addSeparatorView(leftPadding padding: CGFloat = 0) {
        addSubview(separatorView)
        
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    func addSeparatorView(leadingContraint: NSLayoutXAxisAnchor) {
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: leadingContraint, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
