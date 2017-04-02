//
//  ETBaseViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/16.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class ETBaseViewController: ETViewController {
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon_app_logo")
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var logoHeightConstraint: Constraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.dlyThemeColor()
        
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(60)
            make.centerX.equalTo(self.view)
            logoHeightConstraint = make.height.width.equalTo(100).constraint
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ETBaseViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ETBaseViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugLog()
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        logoHeightConstraint.update(offset: 0)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        logoHeightConstraint.update(offset: 100)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
