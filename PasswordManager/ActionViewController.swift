//
//  ActionViewController.swift
//  PasswordManager
//
//  Created by Egetart on 2017/3/21.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import MobileCoreServices
import LocalAuthentication

class ActionViewController: UIViewController {

    @IBOutlet weak var accountTableView: UITableView!
    
    lazy var accounts = [ETAccount]()
    
    fileprivate let cellReuseIdentifier = "AccountCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "选择账户"
        
        accountTableView.register(ETAccountCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        accountTableView.dataSource = self
        accountTableView.delegate = self
        accountTableView.tableFooterView = UIView()
        accountTableView.estimatedRowHeight = 60
        accountTableView.rowHeight = UITableViewAutomaticDimension
        
        authenticateUsre()
        
//        handleRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func authenticateUsre() {
        let context = LAContext()
        let reason = "使用指纹验证获取账户信息"
        var error: NSError?
        
        if #available(iOS 9.0, *) {
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success: Bool, error: Error?) in
                    if success {
                        OperationQueue.main.addOperation {
                            self.navigationController?.setNavigationBarHidden(false, animated: false)
                            self.accounts = ETDatabaseManager.shared.loadUserAccounts()
                            self.accountTableView.reloadData()
                        }
                    }
                })
            }
        } else {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success: Bool, error: Error?) in
                    if success {
                        OperationQueue.main.addOperation {
                            self.navigationController?.setNavigationBarHidden(false, animated: false)
                            self.accounts = ETDatabaseManager.shared.loadUserAccounts()
                            self.accountTableView.reloadData()
                        }
                    }
                })
            }
        }
        
        if let laError = error as? LAError {
            switch laError.code {
            case .touchIDNotEnrolled:
                self.showError(message: "这台设备未包含任何指纹信息")
            case .passcodeNotSet:
                self.showError(message: "这台设备尚未设置密码")
            default:
                self.showError(message: "Touch ID 不可用")
            }
        }
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(title: "错误提示", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleRequest() {
        guard let item = self.extensionContext?.inputItems.first as? NSExtensionItem,
        let provider = item.attachments?.first as? NSItemProvider
        else { return }
        
        //TODO: 从provider.registeredTypeIdentifiers.last得到操作类型, 根据操作类型执行不同操作
        provider.loadItem(forTypeIdentifier: provider.registeredTypeIdentifiers.last as! String, options: nil) { (itemDictionary, error) in
            let dict = itemDictionary as! NSDictionary
            print(dict)
        }
    }
    
    func completeRequest(account: ETAccount) {
        let accountInfoDict: NSDictionary = ["userName": account.userName, "password": account.password]
        let provider = NSItemProvider(item: accountInfoDict, typeIdentifier: kUTTypePropertyList as String)
        let item = NSExtensionItem()
        item.attachments = [provider]
        self.extensionContext?.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
    @IBAction func cancelRequestAction(_ sender: UIBarButtonItem) {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

extension ActionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! ETAccountCell
        cell.configureCell(account: accounts[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeRequest(account: accounts[indexPath.row])
    }
}

extension ActionViewController: UITableViewDelegate {

}
