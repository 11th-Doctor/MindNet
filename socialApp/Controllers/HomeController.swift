//
//  HomeController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/7.
//

import UIKit

class HomeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = .init(title: "登入", style: .done, target: self, action: #selector(handleLoginButton))
    }
    
    @objc fileprivate func handleLoginButton() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}
