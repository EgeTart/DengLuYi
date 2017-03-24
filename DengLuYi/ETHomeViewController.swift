//
//  ETHomeViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/21.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit

class ETHomeViewController: UIViewController {

    fileprivate let cellReuseIdentifier = "AccountCellReuseIdentifier"
    
    lazy var accountTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ETAccountCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    lazy var addAcountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dlyThemeColor()
        button.setImage(UIImage(named: "icon_add"), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.5
        button.addTarget(self, action: #selector(ETHomeViewController.addAccountAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    lazy var showSideBarItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(image: UIImage(named: "icon_list"), style: .plain, target: self, action: #selector(ETHomeViewController.showSideBarAction(sender:)))
        buttonItem.tintColor = UIColor.white
        return buttonItem
    }()
    
    fileprivate lazy var accounts = [ETAccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accounts = ETDatabaseManager.shared.loadUserAccounts()
        accountTableView.reloadData()
    }
    
    func setupInterface() {
        self.title = "账户列表"
        
        self.view.addSubview(accountTableView)
        self.view.addSubview(addAcountButton)
        
        self.navigationItem.leftBarButtonItem = showSideBarItem
        
        setupViewsConstraints()
    }
    
    func setupViewsConstraints() {
        accountTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addAcountButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    @objc private func showSideBarAction(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(animated: true)
    }
    
    @objc private func addAccountAction(sender: UIButton) {
        let addAccountViewController = ETAddAccountViewController()
        self.navigationController?.pushViewController(addAccountViewController, animated: true)
    }
}

extension ETHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ETAccountCell
        cell.configureCell(account: accounts[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

extension ETHomeViewController: UITableViewDelegate {

}
