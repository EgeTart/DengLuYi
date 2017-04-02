//
//  DatabaseManager.swift
//  DengLuYi
//
//  Created by Egetart on 2017/3/22.
//  Copyright © 2017年 Egetart. All rights reserved.
//

import Foundation
import FMDB

class ETDatabaseManager {
    
    static let shared = ETDatabaseManager()
    
    private let database: FMDatabase! = {
        let databasePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.PasswordExtension")?.appendingPathComponent("account.sqlite").path
        print(databasePath!)
        let database = FMDatabase(path: databasePath)
        return database
    }()
    
    private var userName: String
    
    private init() {
        
        let userDefault = UserDefaults(suiteName: "group.PasswordExtension")
        userName = userDefault?.value(forKey: "kUserName") as! String
        
        createAccountTable()
    }
    
    private func createAccountTable() {
        if !database.open() {
            print("数据库打开失败")
            return
        }
        
        let createAccountTableSql = "CREATE TABLE IF NOT EXISTS \(userName)(id INTEGER PRIMARY KEY AUTOINCREMENT, account_name TEXT NOT NULL UNIQUE, user_name TEXT NOT NULL, email TEXT, phone_number TEXT, password TEXT NOT NULL)"
        let isSuccess = database.executeStatements(createAccountTableSql, withResultBlock: nil)
        
        if isSuccess {
            print("成功创建表")
        }
        else {
            print("创建表失败")
        }
    }
    
    func loadUserAccounts() -> [ETAccount] {
        let queryAcountsSql = "SELECT account_name, user_name, password, phone_number, email FROM \(userName)"
        
        var accounts = [ETAccount]()
        do {
            let resultSet = try database.executeQuery(queryAcountsSql, values: nil)
            while resultSet.next() {
                let accountName = resultSet.string(forColumn: "account_name")!
                let userName = resultSet.string(forColumn: "user_name")!
                let password = resultSet.string(forColumn: "password")!
                let phoneNumber = resultSet.string(forColumn: "phone_number")
                let email = resultSet.string(forColumn: "email")
                
                let account = ETAccount(accountName: accountName, userName: userName, password: password, phoneNumber: phoneNumber, email: email)
                accounts.append(account)
            }
        }
        catch {
            print(error)
        }
        
        return accounts
    }
    
    func addAcount(account: ETAccount) {
        
        var values = [account.accountName, account.userName, account.password]
        var fields = "account_name, user_name, password"
        var valuesPlaceholder = "?, ?, ?"
        
        if let email = account.email {
            values.append(email)
            fields.append(", email")
            valuesPlaceholder.append(", ?")
        }
        
        if let phoneNumber = account.phoneNumber {
            values.append(phoneNumber)
            fields.append(", phone_number")
            valuesPlaceholder.append(", ?")
        }
        
        let insertAccountSql = "INSERT INTO \(userName)(\(fields)) VALUES(\(valuesPlaceholder))"

        do {
            try database.executeUpdate(insertAccountSql, values: values)
        }
        catch {
            print(error)
        }
    }
    
    func updateUserAccountInfo(accounts: [ETAccount]) {
        let deleteAccountAccountSql = "DELETE FROM \(userName)"
        
        do {
            try database.executeUpdate(deleteAccountAccountSql, values: nil)
            for account in accounts {
                self.addAcount(account: account)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
