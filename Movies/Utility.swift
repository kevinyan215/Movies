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

func signOutUser() {
    userDefaults.removeObject(forKey: sessionIdIdentifier)
}
