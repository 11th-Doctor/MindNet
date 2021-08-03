//
//  ProfileController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/17.
//

import UIKit
import JGProgressHUD

class ProfileController: BaseHeaderCollectionController<PostCell, Post, ProfileHeader> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "個人資料"
        fetchUserProfile()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "fetch", style: .done, target: self, action: #selector(fetchUserProfile))
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(fetchUserProfile), for: .valueChanged)
    }
    
    var user: User?
    
    override func setupHeader(header: ProfileHeader) {
        header.profileController = self
        header.user = user
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
        
        Service.shared.fetchUserProfile { result in
            switch result {
            case .failure(let err):
                print("Failed to fetch user profile", err)
                break
            case .success(let user):
                self.user = user
                self.items = user.posts ?? [Post]()
                self.collectionView.reloadData()
                break
            }
            hud.dismiss(animated: true)
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    fileprivate func uploadUserProfileImage(profileImage: UIImage) {
        if let user = user {
            Service.shared.updateProfile(user: user, avatar: profileImage) { result in
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
}

extension ProfileController: PostDelegate {
    func showOptions(postId: String) {
        let alertController = UIAlertController(title: "選單", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "刪除貼文", style: .destructive) { _ in
            Service.shared.deletePost(postId: postId) { result in
                switch result {
                case .failure(let err):
                    print(err)
                    break
                case .success(_):
                    self.fetchUserProfile()
                }
            }
        })
        
        alertController.addAction(.init(title: "取消", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
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
