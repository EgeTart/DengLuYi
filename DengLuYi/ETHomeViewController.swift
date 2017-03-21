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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50.0
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
        return button
    }()
    
    
    lazy var showSideBarItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(image: UIImage(named: "icon_list"), style: .plain, target: self, action: #selector(ETHomeViewController.showSideBarAction(sender:)))
        buttonItem.tintColor = UIColor.white
        return buttonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    func setupInterface() {
        self.title = "我的账户列表"
        
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
    
    func showSideBarAction(sender: UIBarButtonItem) {
        self.revealViewController().revealToggle(animated: true)
    }
}

extension ETHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.imageView?.image = UIImage(named: "icon_key")
        cell.textLabel?.text = "Hello"
        return cell
    }
}

extension ETHomeViewController: UITableViewDelegate {

}
