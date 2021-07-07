//
//  ViewController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/4.
//

import UIKit
import JGProgressHUD

class LoginController: UIViewController {
    
    let logoImageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "startup"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "FullStack Social"
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .natural
        label.numberOfLines = 0
        return label
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登入", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "您的登入身份有誤，請再試一次"
        label.textColor = .red
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let goToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("返回註冊", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        
        return button
    }()
    
    var formView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.alwaysBounceVertical = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    @objc fileprivate func handleLogin() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view, animated: true)
        
        Service.shared.login(email: email, password: password) { result in
            switch (result) {
            case .failure(let err):
                print("Failed to login", err.localizedDescription)
                break
            case.success(let data):
                print(String.init(data: data, encoding: .utf8) ?? "")
                break
            }

            hud.dismiss(animated: true)
        }
    }
    
    @objc fileprivate func goToRegister() {
        print("going back to register...")
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        view.addSubview(formView)
        
        formView.addSubview(logoImageView)
        formView.addSubview(logoLabel)
        formView.addSubview(emailTextField)
        formView.addSubview(passwordTextField)
        formView.addSubview(loginButton)
        formView.addSubview(errorLabel)
        
        formView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let logoStack = UIStackView(arrangedSubviews: [logoImageView,logoLabel])
        formView.addSubview(logoStack)
        
        logoStack.axis = .horizontal
        logoStack.distribution = .fillEqually
        logoStack.anchor(top: formView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 150, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 80)
        logoStack.centerXAnchor.constraint(equalTo: formView.centerXAnchor).isActive = true
//        logoStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        logoStack.widthAnchor.constraint(equalTo: formView.widthAnchor, multiplier: 3/4).isActive = true
        
        let fieldsStack = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton,errorLabel,goToRegisterButton])
        fieldsStack.axis = .vertical
        fieldsStack.distribution = .fillEqually
        fieldsStack.spacing = 16
        formView.addSubview(fieldsStack)
        
        fieldsStack.anchor(top: logoStack.bottomAnchor, left: formView.leftAnchor, bottom: formView.bottomAnchor, right: formView.rightAnchor, paddingTop: 48, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        fieldsStack.widthAnchor.constraint(equalTo: formView.widthAnchor, multiplier: 10/12).isActive = true
        fieldsStack.heightAnchor.constraint(equalTo: fieldsStack.widthAnchor, multiplier: 0.95).isActive = true
        
    }
}

