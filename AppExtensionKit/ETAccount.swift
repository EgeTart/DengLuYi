//
//  ETAccount.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/22.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import Foundation

public struct ETAccount {
    
    var accountName: String
    var accountIdentifier: String
    var userName: String
    var email: String?
    var phoneNumber: String?
    var password: String
    
    init(accountName: String, accountIdentifier: String, userName: String, password: String, phoneNumber: String? = nil, email: String? = nil) {
        self.accountName = accountName
        self.accountIdentifier = accountIdentifier
        self.userName = userName
        self.password = password
        self.phoneNumber = phoneNumber
        self.email = email
    }
}
