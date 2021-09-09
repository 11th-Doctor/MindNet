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
        label.text = "社群 Social"
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
        textField.tag = 0
        return textField
    }()
    
    let passwordTextField: IndentedTextField = {
        let textField = IndentedTextField(padding: 24)
        textField.placeholder = "密碼"
        textField.layer.cornerRadius = 25
        textField.keyboardType = .emailAddress
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.tag = 1
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
        label.isHidden = true
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
    
    lazy var formView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.keyboardDismissMode = .interactive
        view.bounces = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapping)))
        //TODO: - keyboard dismissing
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc fileprivate func handleTapping() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
                self.errorLabel.isHidden = false
                break
            case.success(_):
                self.dismiss(animated: true) {
                    if let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController {
                        mainTabBarController.refreshPosts()
                        UserDefaults.standard.setValue(email, forKey: "email")
                    }
                }
                break
            }

            hud.dismiss(animated: true)
        }
    }
    
    @objc fileprivate func goToRegister() {
        let registerController = RegisterController()
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    fileprivate func setupViews() {
        
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .init(white: 0.95, alpha: 1)
        
        view.addSubview(formView)
        formView.addSubview(logoImageView)
        formView.addSubview(logoLabel)
        formView.addSubview(errorLabel)
        
        formView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                        paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let logoStack = UIStackView(arrangedSubviews: [logoImageView,logoLabel])
        formView.addSubview(logoStack)
        
        logoStack.axis = .horizontal
        logoStack.distribution = .fillEqually
        logoStack.anchor(top: formView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 150, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 80)
        logoStack.centerXAnchor.constraint(equalTo: formView.centerXAnchor).isActive = true
//        logoStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        logoStack.widthAnchor.constraint(equalTo: formView.widthAnchor, multiplier: 3/4).isActive = true
        
        let fieldsStack = UIStackView(arrangedSubviews: [emailTextField,passwordTextField])
        fieldsStack.axis = .vertical
        fieldsStack.distribution = .fillEqually
        fieldsStack.spacing = 16
        formView.addSubview(fieldsStack)
        
        fieldsStack.anchor(top: logoStack.bottomAnchor, left: formView.leftAnchor, bottom: formView.bottomAnchor, right: formView.rightAnchor, paddingTop: 48, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
        fieldsStack.widthAnchor.constraint(equalTo: formView.widthAnchor, multiplier: 10/12).isActive = true
        fieldsStack.heightAnchor.constraint(equalTo: fieldsStack.widthAnchor, multiplier: 1/3).isActive = true
        
        formView.addSubview(errorLabel)
        errorLabel.anchor(top: fieldsStack.bottomAnchor, left: fieldsStack.leftAnchor, bottom: nil, right: fieldsStack.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        formView.addSubview(loginButton)
        loginButton.anchor(top: errorLabel.bottomAnchor, left: fieldsStack.leftAnchor, bottom: nil, right: fieldsStack.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        formView.addSubview(goToRegisterButton)
        goToRegisterButton.anchor(top: loginButton.bottomAnchor, left: fieldsStack.leftAnchor, bottom: nil, right: fieldsStack.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    
    
    @objc func handleShowKeyboard(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = value.cgRectValue
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        formView.contentInset = contentInsets
        formView.scrollIndicatorInsets = contentInsets
        
        if (!formView.frame.contains(goToRegisterButton.frame.origin)) {
            formView.scrollRectToVisible(goToRegisterButton.frame, animated: true)
        }
    }
    
    @objc func handleHideKeyboard() {
        formView.contentInset.bottom = 0
        formView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    deinit {
        print("No Retain cylce/Leak")
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.view.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
