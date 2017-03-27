//
//  ETSignUpViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/16.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit
import AVOSCloud

class ETSignUpViewController: ETBaseViewController, UIGestureRecognizerDelegate {

    lazy var userNameInputView: ETInputView = {
        let inputView = ETInputView.createInputView(icon: UIImage(named: "icon_account"), placeholder: "请输入用户名")
        return inputView
    }()
    
    lazy var phoneNumberInputView: ETInputView = {
        let inputView = ETInputView.createInputView(icon: UIImage(named: "icon_phone"), placeholder: "请输入手机号码")
        inputView.textField.keyboardType = .phonePad
        return inputView
    }()
    
    lazy var vertifyCodeInputView: ETInputView = {
        let inputView = ETInputView.createInputView(icon: UIImage(named: "icon_vertify"), placeholder: "请输入验证码")
        inputView.textField.keyboardType = .numberPad
        return inputView
    }()
    
    lazy var getVertifyCodeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dlyGreenColor()
        button.setTitle("获取验证码", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.lightText, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(ETSignUpViewController.getVertifyCodeAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nextStepButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dlyGreenColor()
        button.setTitle("下一步", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.lightText, for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(ETSignUpViewController.nextStepAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    var user: AVUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        user = AVUser()
        userNameInputView.textField.text = "Egetart"
        phoneNumberInputView.textField.text = "18813756456"
        vertifyCodeInputView.textField.text = "123456"
    }

    func setupInterface() {
        self.view.addSubview(userNameInputView)
        self.view.addSubview(phoneNumberInputView)
        self.view.addSubview(vertifyCodeInputView)
        self.view.addSubview(getVertifyCodeButton)
        self.view.addSubview(nextStepButton)
        
        setupViewsConstraints()
    }
    
    func setupViewsConstraints() {
        userNameInputView.snp.makeConstraints { (make) in
            make.width.equalTo(260)
            make.height.equalTo(44)
            make.centerX.equalTo(self.view)
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
        }
        
        phoneNumberInputView.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(userNameInputView)
            make.top.equalTo(userNameInputView.snp.bottom).offset(2)
        }
        
        vertifyCodeInputView.snp.makeConstraints { (make) in
            make.leading.height.equalTo(phoneNumberInputView)
            make.trailing.equalTo(getVertifyCodeButton.snp.leading).offset(-8)
            make.top.equalTo(phoneNumberInputView.snp.bottom).offset(2)
        }
        
        getVertifyCodeButton.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(40)
            make.trailing.equalTo(phoneNumberInputView)
            make.top.equalTo(phoneNumberInputView.snp.bottom).offset(4)
        }
        
        nextStepButton.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(phoneNumberInputView)
            make.top.equalTo(vertifyCodeInputView.snp.bottom).offset(40)
        }
    }
    
// MARK: - Actions
    func getVertifyCodeAction(sender: UIButton) {
        
        // TODO: 检查手机号码格式是否正确
        
        guard let phoneNumber = phoneNumberInputView.textField.text, !phoneNumber.isEmpty else {
            showError(message: "请输入手机号码")
            return
        }
        
        showLoading(text: "获取验证码")
        
        AVOSCloud.requestSmsCode(withPhoneNumber: phoneNumber, appName: "登陆易", operation: "手机号码验证", timeToLive: 10) { (success: Bool, error: Error?) in
            self.dismissLoading()
            if let error = error {
                self.showError(message: error.localizedDescription)
            }
        }
    }
    
    func nextStepAction(sender: UIButton) {
        
        self.view.endEditing(true)
        
        guard let userName = userNameInputView.textField.text,
        let phoneNumber = phoneNumberInputView.textField.text,
        !userName.isEmpty, !phoneNumber.isEmpty
        else {
            showError(message: "用户名和手机号不能留空")
            return
        }
        
        guard let vertifyCode = vertifyCodeInputView.textField.text, !vertifyCode.isEmpty else {
            showError(message: "请输入验证码")
            return
        }
        
        showLoading(text: "验证中")
        AVOSCloud.verifySmsCode(vertifyCode, mobilePhoneNumber: phoneNumber) { (success: Bool, error: Error?) in
            self.dismissLoading()
            if success {
                self.user.username = userName
                self.user.mobilePhoneNumber = phoneNumber
                let userInfoSetupViewController = ETUserInfoSetupViewController(user: self.user)
                self.navigationController?.pushViewController(userInfoSetupViewController, animated: true)
            }
            else {
                if let error = error as? NSError {
                    self.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
