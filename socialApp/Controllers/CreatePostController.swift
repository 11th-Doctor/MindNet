//
//  CreatePostController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/12.
//

import UIKit
import JGProgressHUD
import Alamofire

class CreatePostController: UIViewController {
    let selectedImage: UIImage
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("發布", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "請輸入你的貼文內容"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let postBodyTextView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 14)
        view.backgroundColor = .clear
        return view
    }()
    
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
        super.init(nibName: nil, bundle: nil)
        imageView.image = selectedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc fileprivate func handlePost() {
        
        let url = "\(Service.shared.baseUrl)/post"
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        guard let text = postBodyTextView.text else { return }
        
        AF.upload(multipartFormData: { formData in
            formData.append(Data(text.utf8), withName: "postBody")
            guard let imageData = self.selectedImage.jpegData(compressionQuality: 0.5) else { return }
            formData.append(imageData, withName: "imagefile", fileName: "fileName", mimeType: "image/jpg")
        }, to: url)
        .uploadProgress(queue: .main) { progress in
            DispatchQueue.main.async {
                hud.progress = Float(progress.fractionCompleted)
                hud.textLabel.text = "上傳中\n \(Int(progress.fractionCompleted * 100))% 完成"
            }
        }
        .response { resp in
            switch resp.result {
            
            case .failure(let err):
                print("Failed to hit server", err)
                break
            case .success(_):
                
                hud.dismiss(animated: true)
                
                if let err = resp.error {
                    print("Failed to upload the post", err)
                    return
                }
                
                if let code = resp.response?.statusCode, code >= 300 {
                    print("Failed upload with status:", code)
                    return
                }
                
                self.dismiss(animated: true) {
                    if let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController {
                        mainTabbarController.refreshPosts()
                    }
                }
                
                break
            }
        }
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(postButton)
        view.addSubview(placeHolderLabel)
        view.addSubview(postBodyTextView)
        
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        postButton.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 40)
        placeHolderLabel.anchor(top: postButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        postBodyTextView.anchor(top: placeHolderLabel.bottomAnchor, left: placeHolderLabel.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: -25, paddingLeft: -6, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        postBodyTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreatePostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }
}
