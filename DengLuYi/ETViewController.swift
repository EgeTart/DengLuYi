//
//  ETViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/4/2.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import MBProgressHUD

class ETViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "错误提示", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoading(text: String) {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingView.label.text = "\(text)..."
    }
    
    func dismissLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
