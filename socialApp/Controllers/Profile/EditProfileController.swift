//
//  EditProfileController.swift
//  socialApp
//
//  Created by Daryl on 2021/8/30.
//

import UIKit

class EditProfileController: UIViewController {
    
    let viewModel: UserHeaderViewModel
    
    lazy var profileImageView: CircularImageView = {
        let view = CircularImageView(width: 80)
        view.image = #imageLiteral(resourceName: "user")
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfile)))
        return view
    }()
    
    let fullNameTextField: IndentedTextField = {
        let textField = IndentedTextField(padding: 10)
        textField.placeholder = "使用者名稱"
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .init(white: 0.95, alpha: 1)
        return textField
    }()
    
    let bioTextView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("儲存", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .init(red: 0.2392156860, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: UserHeaderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func uploadUserProfileImage(profileImage: UIImage?) {
        Service.shared.updateProfile(viewModel: viewModel, avatar: profileImage) { result in
            switch result {
            case .failure(let err):
                print(err)
                break
            case .success(_):
//                    self.fetchUserProfile()
                break
            }
        }
    }
    
    @objc fileprivate func editProfile() {
        uploadUserProfileImage(profileImage: profileImageView.image)
    }
    
    @objc fileprivate func selectProfile() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func setupViews() {
        
        view.backgroundColor = .white
        navigationItem.title = "編輯檔案"
        
        view.addSubview(profileImageView)
        view.addSubview(fullNameTextField)
        view.addSubview(bioTextView)
        view.addSubview(editProfileButton)
        
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fullNameTextField.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 44)
        
        bioTextView.anchor(top: fullNameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 120)
        
        editProfileButton.anchor(top: bioTextView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 28)
        editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fullNameTextField.text = viewModel.fullName
        bioTextView.text = viewModel.bio
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            dismiss(animated: true) {
                self.profileImageView.image = image
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
