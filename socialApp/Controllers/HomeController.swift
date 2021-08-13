//
//  HomeController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/7.
//

import UIKit
import JGProgressHUD

class HomeController: BaseCollectionController<PostCell, Post, PostViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = .init(title: "登入", style: .done, target: self, action: #selector(handleLoginButton))
        navigationItem.rightBarButtonItem = .init(image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(searchUsers))
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
    }
    
    @objc fileprivate func handleLoginButton() {
        let loginController = LoginController()
        let navigationController = UINavigationController(rootViewController: loginController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc fileprivate func searchUsers() {
        let usersSearchController = UsersSearchController()
        let navigationController = UINavigationController(rootViewController: usersSearchController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func fetchPosts() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        Service.shared.fetchPosts { result in
            switch result {
            case .failure(let err):
                print("Failed to fetch posts", err.localizedDescription)
                break
            case .success(let postViewModels):
                self.items = postViewModels
                self.collectionView.reloadData()
                break
            }
            self.collectionView.refreshControl?.endRefreshing()
            hud.dismiss(animated: true)
        }
    }
    
    deinit {
        print("No Retain cylce/Leak")
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        return CGSize(width: view.frame.width, height: height)
    }
}

extension HomeController: PostDelegate {
    func showOptions(postId: String) {
        let alertController = UIAlertController(title: "選單", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "刪除貼文", style: .destructive) { _ in
            Service.shared.deletePost(postId: postId) { result in
                switch result {
                case .failure(let err):
                    print(err)
                    break
                case .success(_):
                    if let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController {
                        mainTabBarController.refreshPosts()
                    }
                }
            }
        })
        
        alertController.addAction(.init(title: "取消", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
}
