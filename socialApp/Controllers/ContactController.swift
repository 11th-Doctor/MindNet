//
//  ContactController.swift
//  socialApp
//
//  Created by Daryl on 2021/9/16.
//

import UIKit
import JGProgressHUD

class ContactController: UIViewController {
    
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
        label.text = "簡單說明所發生的狀況"
        return label
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("回報", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(red: 0.2392156860, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleReport), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        navigationItem.title = "回報問題"
        view.backgroundColor = .white
        
        view.addSubview(placeholderLabel)
        view.addSubview(textView)
        view.addSubview(submitButton)
        
        placeholderLabel.anchor(top: textView.topAnchor, left: textView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        textView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 140)
        
        submitButton.anchor(top: textView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 28)
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc fileprivate func handleReport() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        if let description = textView.text, !description.isEmpty {
            
            alertController.message = "是否送出？"
            let params:[String : String] = ["description" : description]
            
            alertController.addAction(.init(title: "回報", style: .default, handler: { [unowned self] _ in
                let hud = JGProgressHUD(style: .dark)
                hud.show(in: self.view)
                self.submitButton.isEnabled = false
                Service.shared.reportIssues(params: params) { [unowned self] _ in
                    hud.dismiss(afterDelay: 2)
                    self.submitButton.isEnabled = true
                    let alert = UIAlertController(title: "回報問題", message: "感謝你寶貴的意見，我們會盡快與你取得聯繫。", preferredStyle: .alert)
                    alert.addAction(.init(title: "確定", style: .default) { [unowned self] _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    self.present(alert, animated: true)
                }
            }))
            
            alertController.addAction(.init(title: "取消", style: .destructive))
        } else {
            alertController.message = "請輸入描述內容。"
            alertController.addAction(.init(title: "確定", style: .default))
        }
        
        present(alertController, animated: true)
    }
    
    @objc fileprivate func handleTextChange() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
