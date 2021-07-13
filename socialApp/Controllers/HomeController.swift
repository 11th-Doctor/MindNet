//
//  HomeController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/7.
//

import UIKit

class HomeController: BaseCollectionController<PostCell, Post> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = .init(title: "登入", style: .done, target: self, action: #selector(handleLoginButton))
        navigationItem.leftBarButtonItem = .init(title: "fetch", style: .done, target: self, action: #selector(fetchPosts))
    }
    
    @objc fileprivate func handleLoginButton() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func fetchPosts() {
        Service.shared.fetchPosts { result in
            switch result {
            case .failure(let err):
                print("Failed to fetch posts", err.localizedDescription)
                break
            case .success(let posts):
                self.items = posts
                break
            }
        }
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        print("h: \(height)")
        return CGSize(width: view.frame.width, height: height)
    }
}
