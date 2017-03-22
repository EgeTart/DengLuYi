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
    
    var accounts: [ETAccount]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accounts = ETDatabaseManager.shared.loadUserAccounts()
        print(accounts.count)
        
        accountTableView.dataSource = self
        accountTableView.delegate = self
        accountTableView.tableFooterView = UIView()
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}

extension ActionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCellReuseIdentifier", for: indexPath)
        cell.textLabel?.text = account.userName
        cell.detailTextLabel?.text = account.appIdentifier
        return cell
    }
}

extension ActionViewController: UITableViewDelegate {

}
