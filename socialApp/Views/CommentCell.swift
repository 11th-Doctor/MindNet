//
//  CommentCell.swift
//  socialApp
//
//  Created by Daryl on 2021/8/21.
//

import UIKit

class CommentCell: BaseCollectionCell<Comment, CommentViewModel> {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
