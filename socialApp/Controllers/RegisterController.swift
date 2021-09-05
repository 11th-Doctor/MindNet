//
//  RegisterController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/17.
//

import UIKit

class RegisterController: UIViewController {
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    let logoImageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "startup"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "社群 Social"
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .natural
        label.numberOfLines = 0
        return label
    }()
    
    let fullnameTextField: IndentedTextField = {
        let textField = IndentedTextField(padding: 24)
        textField.placeholder = "用戶姓名"
        textField.layer.cornerRadius = 25
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        return textField
    }()
    
    let emailTextField: IndentedTextField = {
        let textField = IndentedTextField(padding: 24)
        textField.placeholder = "電子郵件"
        textField.layer.cornerRadius = 25
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: IndentedTextField = {
        let textField = IndentedTextField(padding: 24)
        textField.placeholder = "密碼"
        textField.layer.cornerRadius = 25
        textField.keyboardType = .emailAddress
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("註冊", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    }()
    
    let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("返回登入", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
        return button
    }()
    
    var formView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.keyboardDismissMode = .onDrag
        
        //TODO: - keybpard dismissing
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleRegister() {
        let fullname = fullnameTextField.text ?? ""
        let emall = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if fullname.isEmpty || emall.isEmpty || password.isEmpty {
            let alertController = UIAlertController(title: "註冊失敗", message: "欄位輸入不完整，請再試一試", preferredStyle: .alert)
            alertController.addAction(.init(title: "確定", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let params = ["fullName":fullname, "email":emall, "password":password]

        Service.shared.signUp(params: params) { result in
            switch result {
            case .failure(let err):
                print("Failed to sign up", err)
                break
            case .success(_):
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                break
            }
        }
    }
    
    @objc fileprivate func goToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        view.addSubview(formView)
        
        formView.addSubview(logoImageView)
        formView.addSubview(logoLabel)
        formView.addSubview(emailTextField)
        formView.addSubview(passwordTextField)
        formView.addSubview(registerButton)
        
        formView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let logoStack = UIStackView(arrangedSubviews: [logoImageView,logoLabel])
        formView.addSubview(logoStack)
        
        logoStack.axis = .horizontal
        logoStack.distribution = .fillEqually
        logoStack.anchor(top: formView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 150, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 80)
        logoStack.centerXAnchor.constraint(equalTo: formView.centerXAnchor).isActive = true
//        logoStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        logoStack.widthAnchor.constraint(equalTo: formView.widthAnchor, multiplier: 3/4).isActive = true
        
        let fieldsStack = UIStackView(arrangedSubviews: [fullnameTextField,emailTextField,passwordTextField])
        fieldsStack.axis = .vertical
        fieldsStack.distribution = .fillEqually
        fieldsStack.spacing = 16
        formView.addSubview(fieldsStack)
        
        fieldsStack.anchor(top: logoStack.bottomAnchor, left: formView.leftAnchor, bottom: formView.bottomAnchor, right: formView.rightAnchor, paddingTop: 48, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        fieldsStack.widthAnchor.constraint(equalTo: formView.widthAnchor, multiplier: 10/12).isActive = true
        fieldsStack.heightAnchor.constraint(equalTo: fieldsStack.widthAnchor, multiplier: 1/2).isActive = true
        
        formView.addSubview(registerButton)
        registerButton.anchor(top: fieldsStack.bottomAnchor, left: fieldsStack.leftAnchor, bottom: nil, right: fieldsStack.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        formView.addSubview(goToLoginButton)
        goToLoginButton.anchor(top: registerButton.bottomAnchor, left: fieldsStack.leftAnchor, bottom: nil, right: fieldsStack.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    @objc func handleShowKeyboard(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = value.cgRectValue
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        formView.contentInset = contentInsets
        formView.scrollIndicatorInsets = contentInsets

        var aRect = self.view.frame
        aRect.size.height -= keyboardFrame.size.height

        if (!aRect.contains(goToLoginButton.frame.origin)) {
            formView.scrollRectToVisible(goToLoginButton.frame, animated: true)
        }
    }
    
    @objc func handleHideKeyboard() {
        formView.contentInset = UIEdgeInsets.zero
        formView.verticalScrollIndicatorInsets = UIEdgeInsets.zero
    }
}
