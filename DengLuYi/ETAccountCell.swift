//
//  ETAccountCell.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/24.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import UIKit
import SnapKit

class ETAccountCell: UITableViewCell {
    
    lazy var accountIndicatorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.dlyGreenColor()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        return label
    }()
    
    lazy var accountNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dlyThemeColor()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dlyTitleFontColor()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(accountIndicatorLabel)
        self.contentView.addSubview(accountNameLabel)
        self.contentView.addSubview(userNameLabel)
    }
    
    func configureCell(account: ETAccount) {
        let indicatorIndex = account.accountName.index(after: account.accountName.startIndex)
        let accountIndicator = account.accountName.substring(to: indicatorIndex)
        accountIndicatorLabel.text = accountIndicator
        accountNameLabel.text = account.accountName
        userNameLabel.text = account.userName
        setupViewsConstraints()
    }
    
    private func setupViewsConstraints() {
        accountIndicatorLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.leading.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        accountNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(accountIndicatorLabel.snp.trailing).offset(10)
            make.bottom.equalTo(accountIndicatorLabel.snp.centerY)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(accountNameLabel)
            make.top.equalTo(accountIndicatorLabel.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
