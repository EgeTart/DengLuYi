//
//  ETSignUpViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/16.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit

class ETSignUpViewController: ETBaseViewController {

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
        return button
    }()
    
    lazy var nextStepButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dlyGreenColor()
        button.setTitle("下一步", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.lightText, for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
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
            make.top.equalTo(vertifyCodeInputView.snp.bottom).offset(30)
        }
    }
}
