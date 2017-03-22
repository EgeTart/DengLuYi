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
        let databasePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.dengLuYiExtension")?.appendingPathComponent("account.sqlite").path
        print(databasePath!)
        let database = FMDatabase(path: databasePath)
        return database
    }()
    
    private init() {
        createAccountTable()
    }
    
    private func createAccountTable() {
        if !database.open() {
            print("数据库打开失败")
            return
        }
        
        let createAccountTableSql = "CREATE TABLE IF NOT EXISTS user_account(id INTEGER PRIMARY KEY AUTOINCREMENT, app_identifier TEXT NOT NULL, user_name TEXT NOT NULL, email TEXT, phone_number TEXT, password TEXT NOT NULL)"
        let isSuccess = database.executeStatements(createAccountTableSql, withResultBlock: nil)
        
        if isSuccess {
            print("成功创建表")
        }
        else {
            print("创建表失败")
        }
    }
    
    func loadUserAccounts() -> [ETAccount] {
        let queryAcountsSql = "SELECT app_identifier, user_name, password, phone_number, email FROM user_account"
        
        var accounts = [ETAccount]()
        do {
            let resultSet = try database.executeQuery(queryAcountsSql, values: nil)
            while resultSet.next() {
                let appIdentifier = resultSet.string(forColumn: "app_identifier")!
                let userName = resultSet.string(forColumn: "user_name")!
                let password = resultSet.string(forColumn: "password")!
                let phoneNumber = resultSet.string(forColumn: "phone_number")
                let email = resultSet.string(forColumn: "email")
                
                let account = ETAccount(appIdentifier: appIdentifier, userName: userName, password: password, phoneNumber: phoneNumber, email: email)
                accounts.append(account)
            }
        }
        catch {
            print(error)
        }
        
        return accounts
    }
    
    func generateMockData() {
        let insertAccountSql = "INSERT INTO user_account(app_identifier, user_name, password) VALUES(?, ?, ?)"
        
        do {
            try database.executeUpdate(insertAccountSql, values: ["com.egetart.AApay", "egeatrt", "anys1234"])
        }
        catch {
            print(error)
        }
    }
}
