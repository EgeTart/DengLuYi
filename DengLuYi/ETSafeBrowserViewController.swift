//
//  ETSafeBrowserViewController.swift
//  DengLuYi
//
//  Created by Egetart on 2017/4/1.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit

fileprivate class ETURLInputView: UIView {
    
    lazy var refreshControl: UIControl = {
        let control = UIControl()
        let imageView = UIImageView(image: UIImage(named: "icon_refresh"))
        control.addSubview(imageView)
        
        imageView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        return control
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.tintColor = UIColor.darkGray
        textField.placeholder = "请输入浏览地址"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.keyboardType = .URL
        textField.returnKeyType = .go
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(searchTextField)
        self.addSubview(refreshControl)
        setupViewsConstarints()
    }
    
    private func setupViewsConstarints() {
        searchTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        refreshControl.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ETSafeBrowserViewController: UIViewController, UIGestureRecognizerDelegate {
    
    fileprivate lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.scrollView.keyboardDismissMode = .onDrag
        return webView
    }()
    

    private lazy var URLInputView: ETURLInputView = {
        let inputView = ETURLInputView(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        inputView.searchTextField.delegate = self
        inputView.refreshControl.addTarget(self, action: #selector(ETSafeBrowserViewController.refreshAction(sender:)), for: .touchUpInside)
        inputView.layer.cornerRadius = 15
        inputView.clipsToBounds = true
        return inputView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        let url = URL(string: "http://cn.bing.com/")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupInterface() {
        self.view.backgroundColor = UIColor.white
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .plain, target: self, action: #selector(ETSafeBrowserViewController.backAction(sender:)))
        self.navigationItem.titleView = URLInputView
        
        self.view.addSubview(webView)
        
        setupViewsConstraints()
    }

    private func setupViewsConstraints() {
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    @objc private func backAction(sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func refreshAction(sender: UIControl) {
        debugLog()
    }
}

extension ETSafeBrowserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text,
            let url = URL(string: text) else {
            return false
        }
        
        textField.resignFirstResponder()
        
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
        
        return true
    }
}
