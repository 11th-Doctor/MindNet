//
//  ProfileController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/17.
//

import UIKit
import JGProgressHUD

class ProfileController: BaseHeaderCollectionController<PostCell, Post, PostViewModel , ProfileHeader, User, UserHeaderViewModel> {
    
    let userId: String
    
    init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "個人資料"
        fetchUserProfile()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "fetch", style: .done, target: self, action: #selector(fetchUserProfile))
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(fetchUserProfile), for: .valueChanged)
    }
    
    override func setupHeader(header: ProfileHeader) {
        header.profileController = self
        if let headerViewModel = headerItem {
            header.item = headerViewModel
        }
    }
    
    func selectProfile() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func fetchUserProfile() {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        Service.shared.fetchUserProfile(userId: userId) { result in
            switch result {
            case .failure(let err):
                print("Failed to fetch user profile", err)
                break
            case .success(let user):
                let headerViewModel = UserHeaderViewModel(model: user, isEditable: self.userId.isEmpty)
                self.headerItem = headerViewModel
                let posts = user.posts ?? [Post]()
                let postViewModels = posts.map({ return PostViewModel(model: $0 )})
                self.items = postViewModels
                break
            }
            hud.dismiss(animated: true)
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    fileprivate func uploadUserProfileImage(profileImage: UIImage) {
        if let viewModel = headerItem {
            Service.shared.updateProfile(viewModel: viewModel, avatar: profileImage) { result in
                switch result {
                case .failure(let err):
                    print(err)
                    break
                case .success(_):
                    self.fetchUserProfile()
                    break
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = estimatedCellHeight(for: indexPath, cellWidth: width)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let header = ProfileHeader()
        let largeHeight: CGFloat = 250
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: largeHeight)
        header.layoutIfNeeded()
        let optimalSize = header.systemLayoutSizeFitting(.init(width: view.frame.width, height: largeHeight))
        return optimalSize
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            dismiss(animated: true) {
                self.uploadUserProfileImage(profileImage: image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
