//
//  BaseReusableView.swift
//  socialApp
//
//  Created by Daryl on 2021/8/16.
//

import UIKit

class BaseReusableView<T: Decodable, U: ViewModel<T>>: UICollectionReusableView {
    
    var item: U!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
