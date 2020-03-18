//
//  NetworkingManager.swift
//  Movies
//
//  Created by Kevin Yan on 4/20/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import Foundation

typealias success = (Data?)->Void
typealias failure = (Error?)->Void

struct NetworkingManager {
    
    static let shared = NetworkingManager()
    
    func getRequest(urlRequest: URLRequest, success: @escaping success, failure: @escaping failure) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                failure(error)
            } 
            else {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        success(data)
                    }
                }
            }
        });
        dataTask.resume()
    }
}
