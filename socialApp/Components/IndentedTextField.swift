//
//  File.swift
//  socialApp
//
//  Created by Daryl on 2021/7/7.
//

import UIKit

class IndentedTextField: UITextField {
    
    let padding: CGFloat
    
    init(padding: CGFloat = 0) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: padding, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
