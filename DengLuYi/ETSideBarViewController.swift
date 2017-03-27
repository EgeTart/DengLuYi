//
//  ETSideBarViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/21.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit
import AVOSCloud

fileprivate class ETTableHeaderView: UIView {
    
    lazy var avatartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_avatar")
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.dlyThemeColor()
        self.addSubview(avatartImageView)
        self.addSubview(userNameLabel)
        setupViewsConstraints()
    }
    
    private func setupViewsConstraints() {
        avatartImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(40)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatartImageView)
            make.top.equalTo(avatartImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ETSideBarViewController: UIViewController {
    
    fileprivate let cellReuseIdentifier = "OptionCellReuseIdentifier"
    
    fileprivate lazy var tableHeaderView: ETTableHeaderView = {
        let tableHeaderView = ETTableHeaderView()
        return tableHeaderView
    }()
    
    lazy var optionTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = self.tableHeaderView
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    lazy var options = [
        (name: "扫码登陆", imageName: "icon_scan"),
        (name: "安全浏览", imageName: "icon_browser"),
        (name: "应用设置", imageName: "icon_setting"),
        (name: "分享应用", imageName: "icon_share"),
        (name: "反馈问题", imageName: "icon_feedback"),
        (name: "帮助信息", imageName: "icon_help"),
        (name: "关于应用", imageName: "icon_about")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(optionTableView)
        setupViewsConstraints()
        tableHeaderView.layoutIfNeeded()
        optionTableView.tableHeaderView = tableHeaderView
        
        if let currentUser = AVUser.current() {
            tableHeaderView.userNameLabel.text = currentUser.username
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupViewsConstraints() {
        optionTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableHeaderView.snp.makeConstraints { (make) in
            make.top.equalTo(optionTableView).offset(-20)
            make.leading.trailing.equalTo(self.view)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.revealViewController().revealToggle(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
