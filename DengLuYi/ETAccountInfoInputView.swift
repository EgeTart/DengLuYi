//
//  ETAccountInfoInputView.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/24.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit

class ETAccountInfoInputView: UIView {
    
    class func createAccoutInfoInputView(infoHint: String, placeholder: String, isInfoNecessary: Bool) -> ETAccountInfoInputView {
        let inputView = ETAccountInfoInputView()
        inputView.infoHintLabel.text = infoHint
        inputView.infoTextField.placeholder = placeholder
        inputView.isInfoNecessary = isInfoNecessary
        return inputView
    }
    
    lazy var infoHintLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dlyBodyFontColor()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var asteriskLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = UIColor.red.withAlphaComponent(0.6)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.dlyLineColor().cgColor
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    var isInfoNecessary = false {
        didSet {
            asteriskLabel.isHidden = !isInfoNecessary
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(infoHintLabel)
        self.addSubview(asteriskLabel)
        self.addSubview(infoTextField)
        setupViewsConstraints()
    }
    
    private func setupViewsConstraints() {
        infoHintLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview()
        }
        
        asteriskLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(infoHintLabel)
            make.leading.equalTo(infoHintLabel.snp.trailing).offset(4)
        }
        
        infoTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(infoHintLabel.snp.bottom).offset(4)
            make.height.equalTo(36)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 260, height: UIViewNoIntrinsicMetric)
    }
}
