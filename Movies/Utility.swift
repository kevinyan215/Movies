//
//  GlobalFunctions.swift
//  Movies
//
//  Created by Kevin Yan on 8/15/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import Foundation

let networkManager = NetworkingManager()
let userDefaults = UserDefaults.standard

func userIsSignedIn() -> Bool {
    return userDefaults.value(forKey: sessionIdIdentifier) != nil
}

func getSessionId() -> String {
    return UserDefaults.standard.value(forKey: sessionIdIdentifier) as? String ?? ""
}

func getAccountId() -> Int {
    return userDefaults.integer(forKey: accountIdIdentifier)
}

func deleteUserData() {
    userDefaults.removeObject(forKey: sessionIdIdentifier)
    userDefaults.removeObject(forKey: accountIdIdentifier)
}
