//
//  GlobalFunctions.swift
//  Movies
//
//  Created by Kevin Yan on 8/15/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import Foundation

let networkManager = NetworkingManager.shared
let userDefaults = UserDefaults.standard
let dateFormatter = DateFormatter()

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

func getCurrentTimeInISO8601() -> String {
    return getStringFromDate(Date(), withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
}

func getCurrentDate() -> String {
    return getStringFromDate(Date(), withFormat: "yyyy-MM-dd")
}

func getStringFromDate(_ date: Date, withFormat format: String) -> String {
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func getDateFromString(date: String, withFormat format: String) -> Date? {
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: date)
}

func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print(error)
    }
    
    return nil
}

func parse<T: Decodable>(decodingType: T.Type, jsonData: Data) -> Decodable? {
    do {
        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed)
//        print(decoded)
        let decodedData = try JSONDecoder().decode(decodingType.self,
                                                   from: jsonData)
        return decodedData
    } catch {
        print(error)
    }
    
    return nil
}
