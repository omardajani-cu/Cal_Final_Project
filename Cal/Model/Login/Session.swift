//
//  Session.swift
//  Cal
//
//  Created by Omar Dajani on 11/29/22.
//

import Foundation

/* Pattern: singleton pattern */
class Session: ObservableObject {
    private static var instance: Session = Session()
    var account: Account? = nil
    
    /* Pattern: observer pattern (notifies UI to update view to show signed in content) */
    @Published var signedIn: Bool = false
    
    static func getInstance() -> Session {
        return instance
    }
    
    func getAccount() -> Account? {
        return account
    }
}
