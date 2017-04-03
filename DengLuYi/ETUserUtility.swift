//
//  ETUserUtility.swift
//  DengLuYi
//
//  Created by Egetart on 2017/4/2.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import Foundation
import AVOSCloud

class ETUserUtility {
    
    static let groupName = "group.PasswordExtension"
    static let accountInfoVersionField = "accountInfoVersion"
    static let userNameKey = "kUserName"
    
    class var currentUserName: String {
        let userDefault = UserDefaults(suiteName: groupName)
        return userDefault?.value(forKey: userNameKey) as! String
    }
    
    class func updateDefaultUserInfo() {
        let user = AVUser.current()
        let userDefault = UserDefaults(suiteName: groupName)
        userDefault?.set(nil, forKey: "kUserObjectId")
        userDefault?.set(nil, forKey: userNameKey)
        userDefault?.set(user?.objectId, forKey: "kUserObjectId")
        userDefault?.set(user?.username, forKey: userNameKey)
        userDefault?.synchronize()
    }
    
    class func updateAccountInfoVersion() {
        guard let user = AVUser.current(),
            let version = user[accountInfoVersionField] as? Int else {
                return
        }
        
        user.setObject(version + 1, forKey: accountInfoVersionField)
        user.save()
    }
    
    class func isNeedToUpdateUserAccountDatabase() -> Bool {
        let userDefault = UserDefaults(suiteName: groupName)
        let accountInfoVersionKey = "kAccountInfoVersion\(self.currentUserName)"
        guard let localAccountInfoVersion = userDefault?.value(forKey: accountInfoVersionKey) as? Int,
        let remoteAccountInfoVersion = AVUser.current()?[accountInfoVersionField] as? Int,
        localAccountInfoVersion == remoteAccountInfoVersion
        else {
            let accountInfoVersion = AVUser.current()?[accountInfoVersionField]
            userDefault?.set(accountInfoVersion, forKey: accountInfoVersionKey)
            return true
        }
        
        return false
    }
}
