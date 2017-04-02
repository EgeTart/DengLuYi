//
//  ViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/13.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit
import AVOSCloud
import MBProgressHUD

class ETSignInViewController: ETBaseViewController {

// MARK: - Properties
    lazy var accountInputView: ETInputView = {
        let inputView = ETInputView.createInputView(icon: UIImage(named: "icon_account"), placeholder: "请输入用户名或手机号码")
        return inputView
    }()
    
    lazy var passwordInputView: ETInputView = {
        let inputView = ETInputView.createInputView(icon: UIImage(named: "icon_password"), placeholder: "请输入密码")
        inputView.textField.isSecureTextEntry = true
        return inputView
    }()
    
    lazy var signUpPromptView: UIView = {
        let promptView = UIView()
        
        let label = UILabel()
        label.text = "首次使用?"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        
        let button = UIButton()
        button.setTitle("注册新账户", for: .normal)
        button.setTitleColor(UIColor.dlyGreenColor(), for: .normal)
        button.setTitleColor(UIColor.lightText, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(ETSignInViewController.signUpAction(sender:)), for: .touchUpInside)
        
        promptView.addSubview(label)
        promptView.addSubview(button)
        
        label.snp.makeConstraints({ (make) in
            make.leading.top.bottom.equalTo(promptView)
        })
        
        button.snp.makeConstraints({ (make) in
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.top.bottom.equalTo(promptView)
        })
        promptView.isUserInteractionEnabled = true
        return promptView
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dlyGreenColor()
        button.setTitle("登陆", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.lightText, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(ETSignInViewController.signInAction(sender:)), for: .touchUpInside)
        return button
    }()

// MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
        accountInputView.textField.text = "Egetart"
        passwordInputView.textField.text = "anys45205"
    }

// MARK: - Interface
    func setupInterface() {
        self.view.addSubview(accountInputView)
        self.view.addSubview(passwordInputView)
        self.view.addSubview(signUpPromptView)
        self.view.addSubview(signInButton)
        
        setupViewsConstraints()
    }
    
    func setupViewsConstraints() {
        accountInputView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(260)
            make.centerX.equalTo(self.view)
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
        }
        
        passwordInputView.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(accountInputView)
            make.top.equalTo(accountInputView.snp.bottom).offset(2)
        }
        
        signUpPromptView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(passwordInputView)
            make.top.equalTo(passwordInputView.snp.bottom).offset(8)
        }
        
        signInButton.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(passwordInputView)
            make.top.equalTo(signUpPromptView.snp.bottom).offset(30)
        }
    }
    
    func showRevealController() {
        let homeViewController = ETHomeViewController()
        let frontNavigationController = UINavigationController(rootViewController: homeViewController)
        frontNavigationController.navigationBar.barTintColor = UIColor.dlyThemeColor()
        frontNavigationController.navigationBar.tintColor = UIColor.white
        frontNavigationController.navigationBar.isTranslucent = false
        frontNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let sideBarViewController = ETSideBarViewController()
        let rearNavigationController = UINavigationController(rootViewController: sideBarViewController)
        
        let revealController = SWRevealViewController(rearViewController: rearNavigationController, frontViewController: frontNavigationController)
        revealController?.rearViewRevealWidth = 230.0 * (self.view.frame.width / 375.0)
        self.navigationController?.pushViewController(revealController!, animated: true)
    }
    
// MARK: - Actions
    func signUpAction(sender: UIButton) {
        let signUpViewConstroller = ETSignUpViewController()
        self.navigationController?.pushViewController(signUpViewConstroller, animated: true)
    }
    
    func signInAction(sender: UIButton) {
        guard let account = accountInputView.textField.text,
        let password = passwordInputView.textField.text,
        !account.isEmpty, !password.isEmpty
        else {
            showError(message: "账号密码不能为空")
            return
        }
        
        showLoading(text: "登陆中")
        
        AVUser.logInWithUsername(inBackground: account, password: password) { (user: AVUser?, error: Error?) in
            self.dismissLoading()
            if let _ = error as? NSError {
                self.showError(message: "请检查用户名或密码是否正确")
            }
            else {
                let userName = user?.username
                let masterKey = user?.object(forKey: "masterKey")
                print(userName!, masterKey!)
                ETUserUtility.updateDefaultUserInfo()
                self.showRevealController()
            }
        }
    }
}

