//
//  Account.swift
//  Cal
//
//  Created by Omar Dajani on 12/1/22.
//

import Foundation

class AccountFactory {
    enum AccountType {
        case customer
        case admin
    }
    
    func create(type: AccountType, data: Data) -> Account? {
        let decoder = JSONDecoder()
        
        switch (type) {
        case .customer:
            do {
                return try decoder.decode(Customer.self, from: data)
            } catch {
                return nil
            }
        case.admin:
            do {
                return try decoder.decode(Admin.self, from: data)
            } catch {
                return nil
            }
        }
    }
}

class Account: Codable {
    private var uid: String = ""
    private var name: String = ""
    private var username: String = ""
    private var role: Int = 0
    
    func getUid() -> String {
        return uid
    }
    func getName() -> String {
        return name
    }
    func getUsername() -> String {
        return username
    }
    func getRole() -> Int {
        return role
    }
}

class Customer: Account {
    
}

class Admin: Account {
    
}
