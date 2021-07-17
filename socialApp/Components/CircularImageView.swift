//
//  CircularImageView.swift
//  socialApp
//
//  Created by Daryl on 2021/7/16.
//

import UIKit

class CircularImageView: UIImageView {
    
    init(width: CGFloat, image: UIImage? = nil) {
        super.init(image: image)
        translatesAutoresizingMaskIntoConstraints = false
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
