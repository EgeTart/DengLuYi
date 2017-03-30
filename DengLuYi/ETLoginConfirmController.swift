//
//  ETLoginConfirmController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/29.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class ETLoginConfirmController: UIViewController {
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_cancel"), for: .normal)
        button.addTarget(self, action: #selector(ETLoginConfirmController.cancelAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("确认登陆", for: .normal)
        button.setTitleColor(UIColor.dlyGreenColor(), for: .normal)
        button.setTitleColor(UIColor.dlyBodyFontColor(), for: .highlighted)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.dlyGreenColor().cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(ETLoginConfirmController.confirmAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var computerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_computer")
        return imageView
    }()
    
    var uuid: String?
    var apiUrl: String?
    var appUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    private func setupInterface() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(cancelButton)
        self.view.addSubview(computerImageView)
        self.view.addSubview(confirmButton)
        setupViewsConstraints()
    }
    
    private func setupViewsConstraints() {
        cancelButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        computerImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(44)
            make.top.equalTo(computerImageView.snp.bottom).offset(12)
        }
    }
    
    @objc private func cancelAction(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirmAction(sender: UIButton) {
        guard let uuid = uuid,
        let apiUrl = apiUrl,
        let appUrl = appUrl
        else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        request(apiUrl + "login", method: .post, parameters: ["uuid": uuid, "user": "egetart", "password": "dengluyi2017", "url": appUrl], encoding: JSONEncoding.default, headers: nil).responseString { (response: DataResponse<String>) in
            if let result = response.value {
                print(result)
                if result != "SUCCESS" {
                    self.showError(errorMessage: "登陆失败")
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func showError(errorMessage: String) {
        let alertController = UIAlertController(title: "错误提示", message: errorMessage, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
}
