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
    var userName: String
    var email: String?
    var phoneNumber: String?
    var password: String
    
    init(accountName: String, userName: String, password: String, phoneNumber: String? = nil, email: String? = nil) {
        self.accountName = accountName
        self.userName = userName
        self.password = password
        self.phoneNumber = phoneNumber
        self.email = email
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["accountName"] = accountName
        dict["userName"] = userName
        dict["password"] = password
        dict["phoneNumber"] = phoneNumber
        dict["email"] = email
        
        return dict
    }
}
