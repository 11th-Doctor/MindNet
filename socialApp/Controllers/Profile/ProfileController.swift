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
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(fetchUserProfile), for: .valueChanged)
        navigationItem.rightBarButtonItem = .init(image: #imageLiteral(resourceName: "post_options"), style: .plain, target: self, action: #selector(handleOptions))
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
    
    @objc fileprivate func handleOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if !userId.isEmpty {
            alertController.addAction(.init(title: "封鎖", style: .destructive, handler: { [unowned self] _ in
                
                let alertController = UIAlertController(title: "封鎖", message: "他們將無法在 MindNet 找到你的個人檔案、貼文或限時動態，MindNet 也不會讓他們知道你已封鎖他們。", preferredStyle: .alert)
                alertController.addAction(.init(title: "封鎖", style: .default, handler: { _ in
                    let hud = JGProgressHUD(style: .dark)
                    Service.shared.blockUser(userId: userId) { _ in
                        hud.dismiss(afterDelay: 2)
                    }
                }))
                
                alertController.addAction(.init(title: "取消", style: .cancel))
                
                self.present(alertController, animated: true)
            }))
            
            alertController.addAction(.init(title: "檢舉", style: .destructive, handler: { [unowned self] _ in
                let alertController = UIAlertController(title: "檢舉", message: "該用戶是否違反了相關的社群使用規範，包含散播不適當的圖片、文字內容等？", preferredStyle: .alert)
                alertController.addAction(.init(title: "檢舉", style: .default, handler: { _ in
                    let hud = JGProgressHUD(style: .dark)
                    hud.show(in: self.view)
                    Service.shared.reportUser(userId: self.userId) { _ in
                        hud.dismiss(afterDelay: 2)
                    }
                }))
                
                alertController.addAction(.init(title: "否", style: .cancel))
                
                self.present(alertController, animated: true)
            }))
        }
        
        alertController.addAction(.init(title: "回報問題", style: .default, handler: { [unowned self] _ in
            let contactController = ContactController()
            self.navigationController?.pushViewController(contactController, animated: true)
        }))
        
        alertController.addAction(.init(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
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
