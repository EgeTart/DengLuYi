//
//  ETAddAccountViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/24.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import MBProgressHUD

class ETAddAccountViewController: UIViewController {
    
    lazy var scrollView = UIScrollView()

    lazy var accountNameInputView: ETAccountInfoInputView = ETAccountInfoInputView.createAccoutInfoInputView(infoHint: "账户名称", placeholder: "登陆易账户", isInfoNecessary: true)
    
    lazy var userNameInputView: ETAccountInfoInputView = ETAccountInfoInputView.createAccoutInfoInputView(infoHint: "用户名", placeholder: "user name", isInfoNecessary: true)
    
    lazy var emailInputView: ETAccountInfoInputView = ETAccountInfoInputView.createAccoutInfoInputView(infoHint: "邮箱地址", placeholder: "example@163.com", isInfoNecessary: false)
    
    lazy var phoneNumberInputView: ETAccountInfoInputView = ETAccountInfoInputView.createAccoutInfoInputView(infoHint: "手机号码", placeholder: "19349205550", isInfoNecessary: false)
    
    lazy var passwordInputView: ETAccountInfoInputView = {
        let inputView = ETAccountInfoInputView.createAccoutInfoInputView(infoHint: "密码", placeholder: "password", isInfoNecessary: true)
        inputView.infoTextField.isSecureTextEntry = true
        return inputView
    }()
    
    lazy var addAcountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dlyGreenColor()
        button.setTitle("添加账户", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.dlyBodyFontColor(), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(ETAddAccountViewController.addAccountAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: addAcountButton.frame.origin.y + 300.0)
    }
    
    private func setupInterface() {
        self.title = "填写账户信息"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        scrollView.keyboardDismissMode = .onDrag
        self.scrollView.addSubview(accountNameInputView)
        self.scrollView.addSubview(userNameInputView)
        self.scrollView.addSubview(emailInputView)
        self.scrollView.addSubview(phoneNumberInputView)
        self.scrollView.addSubview(passwordInputView)
        self.scrollView.addSubview(addAcountButton)
        setupViewsConstraints()
    }
    
    private func setupViewsConstraints() {
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        accountNameInputView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        userNameInputView.snp.makeConstraints { (make) in
            make.top.equalTo(accountNameInputView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        emailInputView.snp.makeConstraints { (make) in
            make.top.equalTo(userNameInputView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        phoneNumberInputView.snp.makeConstraints { (make) in
            make.top.equalTo(emailInputView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        passwordInputView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumberInputView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        addAcountButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(260)
            make.centerX.equalTo(self.view)
            make.top.equalTo(passwordInputView.snp.bottom).offset(30)
        }
    }
    
    private func inputValidCheck() -> (Bool, ETAccount?) {
        guard let accountName = accountNameInputView.infoTextField.text,
        let userName = userNameInputView.infoTextField.text,
        let password = passwordInputView.infoTextField.text,
        !accountName.isEmpty, !userName.isEmpty, !password.isEmpty
        else {
            return (false, nil)
        }
        
        var account = ETAccount(accountName: accountName, userName: userName, password: password)
        
        if let email = emailInputView.infoTextField.text {
            if !email.isEmpty {
                account.email = email
            }
        }
        
        if let phoneNumber = phoneNumberInputView.infoTextField.text {
            if !phoneNumber.isEmpty {
                account.phoneNumber = phoneNumber
            }
        }
        
        return (true, account)
    }
    
    @objc private func addAccountAction(sender: UIButton) {
        let (isValid, account) = inputValidCheck()
        
        if isValid {
            ETDatabaseManager.shared.addAcount(account: account!)
            let successPromptView = MBProgressHUD.showAdded(to: self.view, animated: true)
            successPromptView.mode = .customView
            successPromptView.customView = UIImageView(image: UIImage(named: "icon_success"))
            successPromptView.label.text = "添加成功"
            successPromptView.completionBlock = {
                let _ = self.navigationController?.popViewController(animated: true)
            }
            successPromptView.hide(animated: true, afterDelay: 1.5)
        }
        else {
            let alertController = UIAlertController(title: "信息未填写完整", message: "请填写所有红星标注的必要信息", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}
