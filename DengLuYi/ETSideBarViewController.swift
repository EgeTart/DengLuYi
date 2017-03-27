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
import MBProgressHUD
import SDWebImage

fileprivate class ETTableHeaderView: UIView {
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        if let imageAddress = UserDefaults.standard.object(forKey: "kAvatarImage") as? String {
            imageView.sd_setImage(with: URL(string: imageAddress), placeholderImage: UIImage(named: "image_avatar"))
        }
        else {
            imageView.image = UIImage(named: "image_avatar")
        }
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var avatarControl: UIControl = {
        let control = UIControl()
        control.addSubview(self.avatarImageView)
        return control
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
        self.addSubview(avatarControl)
        self.addSubview(userNameLabel)
        setupViewsConstraints()
    }
    
    private func setupViewsConstraints() {
        avatarControl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(40)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatarControl)
            make.top.equalTo(avatarControl.snp.bottom).offset(10)
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
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        return picker
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
        tableHeaderView.avatarControl.addTarget(self, action: #selector(ETSideBarViewController.changeAvatarAction(sender:)), for: .touchUpInside)
        
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
    
    func showImagePicker() {
        let actionSheet = UIAlertController(title: "更换头像", message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "拍照上传", style: .default) { (action: UIAlertAction) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let chooseFromAlbumAction = UIAlertAction(title: "从相册选择", style: .default) { (action: UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(chooseFromAlbumAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func changeAvatarAction(sender: UIControl) {
        debugLog()
        showImagePicker()
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

extension ETSideBarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.tableHeaderView.avatarImageView.image = pickImage
            
            let compressImage = pickImage.compressedImage()
            let data = UIImagePNGRepresentation(compressImage)
            let file = AVFile(name: "avatar.png", data: data!)
            
            let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingView.label.text = "正在上传..."
            
            file.saveInBackground({ (success: Bool, error: Error?) in
                loadingView.hide(animated: true)
                UserDefaults.standard.set(file.url, forKey: "kAvatarImage")
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
