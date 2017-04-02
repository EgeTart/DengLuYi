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
import QRCodeReader
import AVFoundation
import Alamofire

fileprivate class ETTableHeaderView: UIView {
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        if let imageAddress = AVUser.current()?["avatarImage"] as? String {
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
    
    private lazy var optionTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = self.tableHeaderView
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        return picker
    }()
    
    fileprivate lazy var qrCodeReaderController: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder()
        builder.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        builder.showSwitchCameraButton = false
        builder.showTorchButton = true
        builder.cancelButtonTitle = "取消"
        let readerController = QRCodeReaderViewController(builder: builder)
        readerController.delegate = self
        readerController.title = "扫码登陆"
        return readerController
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
        
        configureSessionManager()
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
    
    private func showImagePicker() {
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
    
    @objc private func changeAvatarAction(sender: UIControl) {
        showImagePicker()
    }
    
    fileprivate func showError(errorMessage: String) {
        let alertController = UIAlertController(title: "错误提示", message: errorMessage, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: { action in
            self.qrCodeReaderController.startScanning()
        })
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
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
        
        guard let frontViewController = self.revealViewController().frontViewController as? UINavigationController else {
            return
        }
        
        switch indexPath.row {
        case 0:
            frontViewController.pushViewController(qrCodeReaderController, animated: true)
        case 1:
            let safeBrowserViewController = ETSafeBrowserViewController()
            frontViewController.pushViewController(safeBrowserViewController, animated: true)
        default:
            break
        }
        
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
                let user = AVUser.current()
                user?.setObject(file.url, forKey: "avatarImage")
                user?.save()
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ETSideBarViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print(result.value)
        
        let loginInfos = result.value.components(separatedBy: "|")
        
        if loginInfos.count != 3 {
            showError(errorMessage: "未能识别的二维码")
            reader.stopScanning()
            return
        }
        
        let apiUrl = loginInfos[0].replacingOccurrences(of: "-", with: "/")
        let uuid = loginInfos[1]
        let appUrl = loginInfos[2]
        print(apiUrl)
        request(apiUrl + "scan", method: .post, parameters: ["uuid": uuid, "url": appUrl], encoding: JSONEncoding.default, headers: nil).responseString { (response: DataResponse<String>) in
            
            if let result = response.value {
                print(result)
                if result == "CONFIRM" {
                    let loginConfirmViewController = ETLoginConfirmController()
                    loginConfirmViewController.apiUrl = apiUrl
                    loginConfirmViewController.uuid = uuid
                    loginConfirmViewController.appUrl = appUrl
                    reader.present(loginConfirmViewController, animated: true, completion: nil)
                }
                else {
                    
                }
                let _ = reader.navigationController?.popViewController(animated: true)
            }
        }
    }

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
    
    }
    

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        let _ = reader.navigationController?.popViewController(animated: true)
    }

}

extension ETSideBarViewController {
    
    struct IdentityAndTrust {
        var identityRef:SecIdentity
        var trust:SecTrust
        var certArray:AnyObject
    }
    
    func configureSessionManager() {
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                print("服务端证书验证")
                let serverTrust: SecTrust = challenge.protectionSpace.serverTrust!
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
                let remoteCertificateData = CFBridgingRetain(SecCertificateCopyData(certificate))!
                let cerPath = Bundle.main.path(forResource: "dengLuYi", ofType: "cer")!
                let cerUrl = URL(fileURLWithPath: cerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)
                
                if remoteCertificateData.isEqual(localCertificateData) {
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
                }
                else {
                    return (URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
                }
            }
            else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
                print("客户端证书验证")
                let identityAndTrust = self.extractIdentity()
                
                let urlCredential = URLCredential(identity: identityAndTrust.identityRef, certificates: identityAndTrust.certArray as? [Any], persistence: URLCredential.Persistence.forSession)
                
                return (URLSession.AuthChallengeDisposition.useCredential, urlCredential)
            }
            else {
                print("其它情况（不接受认证）")
                return (URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust: IdentityAndTrust!
        var securityError: OSStatus = errSecSuccess
        
        let path = Bundle.main.path(forResource: "dengLuYi", ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile: path)!
        let key = kSecImportExportPassphrase as NSString
        let options: NSDictionary = [key: "wislab2016"]
        
        var items: CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess {
            let certItems: CFArray = items as CFArray!
            let certItemsArray: Array = certItems as Array
            let dict: AnyObject? = certItemsArray.first
            if let certEntry = dict as? Dictionary<String, AnyObject> {
                let identityPointer = certEntry["identity"]
                let secIdentityRef = identityPointer as! SecIdentity
                print("\(identityPointer) ------------------ \(secIdentityRef)")
                
                let trustPointer = certEntry["trust"]
                let trustRef = trustPointer as! SecTrust
                print("\(trustPointer) ---------------- \(trustRef)")
                
                let chainPointer = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef, trust: trustRef, certArray: chainPointer!)
            }
        }
        
        return identityAndTrust
    }

}
