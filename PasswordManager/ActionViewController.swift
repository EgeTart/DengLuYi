//
//  ActionViewController.swift
//  PasswordManager
//
//  Created by Egetart on 2017/3/21.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var accountTableView: UITableView!
    
    lazy var accounts = [ETAccount]()
    
    fileprivate let cellReuseIdentifier = "AccountCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accounts = ETDatabaseManager.shared.loadUserAccounts()
        print(accounts.count)
        
        accountTableView.register(ETAccountCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        accountTableView.dataSource = self
        accountTableView.delegate = self
        accountTableView.tableFooterView = UIView()
        accountTableView.estimatedRowHeight = 60
        accountTableView.rowHeight = UITableViewAutomaticDimension
        
        handleRequest()
    }
    
    @IBAction func cancelRequestAction(_ sender: UIBarButtonItem) {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
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
