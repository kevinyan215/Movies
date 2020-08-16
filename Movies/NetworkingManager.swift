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

//typealias success = (Decodable?) -> Void
//typealias failure = (Error?) -> Void

class NetworkingManager {
    
    static let shared = NetworkingManager()
    var pageNumber = 1
    var nowPlayingMoviesPageNumber = 1
    var upcomingMoviesPageNumber = 1
    var topRatedMoviesPageNumber = 1
    
    func request(url: URL, success: @escaping success, failure: @escaping failure) {
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
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
        })
        dataTask.resume()
    }
    
    func request(urlRequest: URLRequest, success: @escaping success, failure: @escaping failure) {
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
        })
        dataTask.resume()
    }
    
    func request(urlRequest: URLRequest, completionHandler completion: @escaping (Data?,Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                completion(data,error)
            }
            else {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        completion(data, error)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func request<T: Decodable>(with request: URLRequest,
                                    decodingType: T.Type,
                                    completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                completion(data,error)
            }
            else {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let data = data {
                            do {
                                let response = try JSONDecoder().decode(decodingType.self, from: data)
                                completion(response,error)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func request<T: Decodable>(with request: URLRequest,
                                    decodingType: T.Type,
                                    success: @escaping (Decodable?) -> Void,
                                    failure: @escaping (Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                failure(error)
            }
            else {
                if let response = response as? HTTPURLResponse {
//                    if response.statusCode == 200 {
                        if let data = data {
                            do {
                                let response = try JSONDecoder().decode(decodingType.self, from: data)
                                success(response)
                            } catch {
                                print(error)
                            }
                        }
//                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func getWatchListFor(sessionId: String, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: APIKeyValue),
                          URLQueryItem(name: "language", value: "en-US"),
                          URLQueryItem(name: "session_id", value: sessionId)]
        var urlComps = URLComponents(string: "https://api.themoviedb.org/3/account/%7Baccount_id%7D/watchlist/movies?")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return  }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)
    }
    
    func newSession(requestToken: String, success: @escaping(Decodable?) -> Void, failure: @escaping (Error?) -> Void) {
        let queryItems = [URLQueryItem(name: "request_token", value: requestToken), URLQueryItem(name: "api_key", value: APIKeyValue)]
        var urlComps = URLComponents(string: newSessionUrl)
        urlComps?.queryItems = queryItems
        if let url = urlComps?.url {
            self.request(with: URLRequest(url: url), decodingType: Session.self, success: success, failure: failure)
        }
        
    }
    
    func validateWithLogin(username: String, password: String, requestToken: String, completion: @escaping (String?) -> Void) {
        let queryItems = [URLQueryItem(name: "username", value: username), URLQueryItem(name: "password", value: password), URLQueryItem(name: "request_token", value: requestToken), URLQueryItem(name: "api_key", value: APIKeyValue)]
        var urlComps = URLComponents(string: validateWithLoginUrl)
        urlComps?.queryItems = queryItems
        let url = urlComps?.url
        if let url = url {
            self.request(url: url, success: {
                data in
                if let data = data {
                    
                    var response: [String:Any]?
                    do {
                        response = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        completion(response?["request_token"] as! String)
                    } catch {
                        print(error)
                    }
                }
            }, failure: {
                result in print(result)
            })
        }
    }
    
    func getRequestToken(success: @escaping (Decodable?) -> Void, failure: @escaping (Error?) -> Void) {
        if let url = URL(string: requestNewTokenUrl) {
            self.request(with: URLRequest(url: url), decodingType: RequestToken.self, success: success, failure: failure)
        }
    }
    
    func getPopularMoviesWith(pageNumber: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        guard let url = URL(string: movieBaseUrl + popularMovieQuery + APIKey + "&page=" + String(pageNumber) + region + USRegion) else { return  }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)
        }
    
    func getNowPlayingMoviesWith(pageNumber: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        guard let url = URL(string: movieBaseUrl + nowPlayingQuery + APIKey + "&page=" + String(pageNumber) + region + USRegion) else { return  }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)
    }
    
    
    func getUpcomingMoviesWith(pageNumber: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        guard let url = URL(string: movieBaseUrl + upcomingQuery + APIKey + "&page=" + String(pageNumber) + region + USRegion) else { return  }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)

    }
    
    func getTopRatedWith(pageNumber: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        guard let url = URL(string: movieBaseUrl + topRatedQuery + APIKey + "&page=" + String(topRatedMoviesPageNumber) + region + USRegion) else { return  }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)
    }
    
    func getMovieDetailAt(_ movieId: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        let movieIdQuery = "\(movieId)?"
        guard let url = URL(string: movieBaseUrl + movieIdQuery + APIKey + "&append_to_response=videos,images") else { return  }
        self.request(with: URLRequest(url: url), decodingType: MovieDetail.self, completionHandler: completion)
        
    }
    
    func getMoviePosterImagesAt(_ posterPath: String?, completion: @escaping (Data?, Error?) -> Void) {
        if let posterPath = posterPath {
            if let posterPathUrl = URL(string: tmdbImageBaseUrl + posterPath) {
                self.request(urlRequest: URLRequest(url: posterPathUrl), completionHandler: completion)
            }
        }
    }
    
}
