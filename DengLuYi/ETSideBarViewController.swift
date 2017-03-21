//
//  ETSideBarViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/21.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit

class ETSideBarViewController: UIViewController {
    
    fileprivate let cellReuseIdentifier = "OptionCellReuseIdentifier"
    
    lazy var optionTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()

    lazy var options = [
        (name: "扫码登陆", imageName: "icon_list"),
        (name: "安全浏览", imageName: "icon_list"),
        (name: "应用设置", imageName: "icon_list"),
        (name: "分享应用", imageName: "icon_list"),
        (name: "反馈问题", imageName: "icon_list"),
        (name: "帮助信息", imageName: "icon_list"),
        (name: "关于应用", imageName: "icon_list")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(optionTableView)
        setupViewsConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupViewsConstraints() {
        optionTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ETSideBarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.imageView?.image = UIImage(named: option.imageName)
        cell.textLabel?.text = option.name
        return cell
    }
}

extension ETSideBarViewController: UITableViewDelegate {

}
