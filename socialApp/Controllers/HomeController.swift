//
//  HomeController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/7.
//

import UIKit
import JGProgressHUD

class HomeController: BaseCollectionController<PostCell, Post, PostViewModel> {
    
    let headerId = "headerId"
    var fetchingFollowingAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        if UserDefaults.standard.string(forKey: "email") == nil {
            let loginController = LoginController()
            loginController.isModalInPresentation = true
            let navController = UINavigationController(rootViewController: loginController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            
            return
        }
        
        fetchPosts()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! FollowingHeader
        header.viewModel.parentViewController = self
        fetchingFollowingAction = header.fetchingFollowingAction
        return header
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        collectionView.register(FollowingHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
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
        
        Service.shared.fetchPosts { [weak self] result in
            switch result {
            case .failure(let err):
                print("Failed to fetch posts", err.localizedDescription)
                break
            case .success(let postViewModels):
                self?.items = postViewModels
                self?.collectionView.reloadData()
                break
            }
            self?.fetchingFollowingAction?()
            self?.collectionView.refreshControl?.endRefreshing()
            hud.dismiss(animated: true)
        }
    }
    
    deinit {
        print("No Retain cycle/Leak for \(String(describing: self))")
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        return CGSize(width: view.frame.width, height: height)
    }
}
