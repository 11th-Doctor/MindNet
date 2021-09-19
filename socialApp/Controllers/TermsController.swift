//
//  TermsController.swift
//  socialApp
//
//  Created by Daryl on 2021/9/17.
//

import UIKit
import Alamofire
import JGProgressHUD

class TermsController: UIViewController {
    
    let textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isSelectable = false
        return view
    }()
    
    let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("接受", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(red: 0.2392156860, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleAgree), for: .touchUpInside)
        return button
    }()
    
    let declineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("拒絕", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleDecline), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        let url = "\(Service.shared.baseUrl)/static/terms.txt"
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .response { [weak self] dataResp in
                let terms = String(data: dataResp.data ?? Data(), encoding: .utf8)
                self?.textView.text = terms
                hud.dismiss()
            }
    }
    
    @objc fileprivate func handleAgree() {
        dismiss(animated: true) {
            UserDefaults.standard.setValue("agreed", forKey: "eula")
        }
    }
    
    @objc fileprivate func handleDecline() {
        dismiss(animated: true)
    }
    
    func setupViews() {
        navigationItem.title = "Terms of Use 使用說明"
        view.backgroundColor = .white
        view.addSubview(textView)
        view.addSubview(agreeButton)
        view.addSubview(declineButton)
        
        textView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: agreeButton.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, width: 0, height: 0)
        
        agreeButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 32, width: 100, height: 28)
        
        declineButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 32, paddingBottom: 16, paddingRight: 0, width: 100, height: 28)
    }
}
