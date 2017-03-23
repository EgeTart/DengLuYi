//
//  ETAccount.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/22.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import Foundation

public struct ETAccount {
    
    var accountIdentifier: String
    var userName: String
    var email: String?
    var phoneNumber: String?
    var password: String
    
    init(accountIdentifier: String, userName: String, password: String, phoneNumber: String? = nil, email: String? = nil) {
        self.accountIdentifier = accountIdentifier
        self.userName = userName
        self.password = password
        self.phoneNumber = phoneNumber
        self.email = email
    }
}
