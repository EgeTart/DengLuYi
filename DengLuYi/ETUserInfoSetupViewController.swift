//
//  ETUserInfoSetupViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/20.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import LeanCloud

class ETUserInfoSetupViewController: ETBaseViewController {

    lazy var passwordInputView: ETInputView = {
        let inputView = ETInputView.createInputView(icon: UIImage(named: "icon_password"), placeholder: "请设置您的密码")
        inputView.textField.isSecureTextEntry = true
        return inputView
    }()
    
    lazy var passwordConfirmInputView: ETInputView = {
        let inputView = ETInputView.createInputView(icon: UIImage(named: "icon_password"), placeholder: "确认密码")
        inputView.textField.isSecureTextEntry = true
        return inputView
    }()
    
    lazy var masterKeyInputView: ETInputView = {
        let inputView = ETInputView.createInputView(icon: UIImage(named: "icon_key"), placeholder: "请设置您的管理密钥")
        inputView.textField.isSecureTextEntry = true
        return inputView
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dlyGreenColor()
        button.setTitle("注册", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.lightText, for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(ETUserInfoSetupViewController.signUpAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    var user: LCUser!
    
    init(user: LCUser) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    func setupInterface() {
        self.view.addSubview(passwordInputView)
        self.view.addSubview(passwordConfirmInputView)
        self.view.addSubview(masterKeyInputView)
        self.view.addSubview(signUpButton)
        
        setupViewsConstraints()
    }
    
    func setupViewsConstraints() {
        passwordInputView.snp.makeConstraints { (make) in
            make.width.equalTo(260)
            make.height.equalTo(44)
            make.centerX.equalTo(self.view)
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
        }
        
        passwordConfirmInputView.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(passwordInputView)
            make.top.equalTo(passwordInputView.snp.bottom).offset(2)
        }
        
        masterKeyInputView.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(passwordConfirmInputView)
            make.top.equalTo(passwordConfirmInputView.snp.bottom).offset(2)
        }
        
        signUpButton.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(masterKeyInputView)
            make.top.equalTo(masterKeyInputView.snp.bottom).offset(40)
        }
    }
    
    func inputValidCheck() -> Bool {
        guard let password = passwordInputView.textField.text,
        let confirmPassword = passwordConfirmInputView.textField.text,
        let masterKey = masterKeyInputView.textField.text
        else { return false }
        
        if password.isEmpty || confirmPassword.isEmpty || masterKey.isEmpty {
            showError(message: "信息未填写完整")
            return false
        }
        
        if password != confirmPassword {
            showError(message: "两次密码不一致")
            return false
        }
        
        user.password = LCString(password)
        user.set("masterKey", value: masterKey)
        
        return true
    }
    
// MARK: - Actions
    func signUpAction(sender: UIButton) {
        if inputValidCheck() {
            user.signUp({ (result: LCBooleanResult) in
                if let errorMessage = result.error?.reason {
                    self.showError(message: errorMessage)
                }
                else {
                    
                }
            })
        }
    }
}
