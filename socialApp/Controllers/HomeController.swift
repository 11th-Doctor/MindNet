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
        navigationItem.leftBarButtonItem = .init(title: "fetch", style: .done, target: self, action: #selector(fetchPosts))
    }
    
    @objc fileprivate func handleLoginButton() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc fileprivate func fetchPosts() {
        print("Fetching posts...")
    }
}
