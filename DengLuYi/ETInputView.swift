//
//  ETInputView.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/13.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit

class ETInputView: UIView {
    
    class func createInputView(icon: UIImage!, placeholder: String) -> ETInputView {
        let inputView = ETInputView()
        inputView.imageView.image = icon
        
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.lightText])
        inputView.textField.attributedPlaceholder = attributedPlaceholder
        
        return inputView
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return imageView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.dlyGreenColor()
        textField.autocorrectionType = .no
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(imageView)
        self.addSubview(textField)
        
        setupViewsConstraints()
    }
    
    func setupViewsConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(self)
            make.width.equalTo(imageView.snp.height)
        }
        
        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.top.trailing.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
