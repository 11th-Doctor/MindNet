//
//  CustomAccessoryView.swift
//  socialApp
//
//  Created by Daryl on 2021/8/21.
//

import UIKit

class CustomAccessoryView: UIView {
    
    let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .init(white: 0.8, alpha: 0.5)
        view.layer.cornerRadius = 8
        view.font = .systemFont(ofSize: 16)
        view.isScrollEnabled = false
        return view
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.text = "請輸入留言"
        return label
    }()
    
    let submitButton: UIButton = {
        let buttton = UIButton(type: .system)
        buttton.backgroundColor = .white
        buttton.setTitle("送出", for: .normal)
        buttton.setTitleColor(.black, for: .normal)
        buttton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        buttton.layer.cornerRadius = 8
        return buttton
    }()
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), colour: .lightGray)
        
        addSubview(placeholderLabel)
        addSubview(textView)
        addSubview(submitButton)
        
        placeholderLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: superview?.leftAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        placeholderLabel.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor).isActive = true
        
        textView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: submitButton.leftAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 8, width: 0, height: 0)
        
        submitButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 60, height: 60)
        submitButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc fileprivate func handleTextChange() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
