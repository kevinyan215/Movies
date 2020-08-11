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

class NetworkingManager {
    
    static let shared = NetworkingManager()
    var pageNumber = 1
    var nowPlayingMoviesPageNumber = 1
    var upcomingMoviesPageNumber = 1
    var topRatedMoviesPageNumber = 1
    
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
        })
        dataTask.resume()
    }
    
     func getPopularMovies(completion: @escaping (MovieList?) -> Void) {
            if let url = URL(string: movieBaseUrl + popularMovieQuery + APIKey + "&page=" + String(pageNumber) + region + USRegion) {
                let urlRequest = URLRequest(url: url)
                self.getRequest(urlRequest: urlRequest, success: {
                    data in
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(MovieList.self, from: data)
                            self.pageNumber += 1
                            completion(response)
                        } catch {
                            print(error)
                        }
                    }
                }, failure: {
                    result in print(result)
                })
            }
        }
    
    func getNowPlayingMovies(completion: @escaping (MovieList?) -> Void) {
        if let url = URL(string: movieBaseUrl + nowPlayingQuery + APIKey + "&page=" + String(nowPlayingMoviesPageNumber) + region + USRegion){
            let urlRequest = URLRequest(url: url)
            self.getRequest(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(MovieList.self, from: data)
                        self.nowPlayingMoviesPageNumber += 1
                        completion(response)
                    } catch {
                        print(error)
                    }
                }
            }, failure: {
                result in print(result)
            })
        }
    }
    
    func getUpcomingMovies(completion: @escaping (MovieList?) -> Void) {
        if let url = URL(string: movieBaseUrl + nowPlayingQuery + APIKey + "&page=" + String(upcomingMoviesPageNumber) + region + USRegion){
            let urlRequest = URLRequest(url: url)
            self.getRequest(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(MovieList.self, from: data)
                        self.upcomingMoviesPageNumber += 1
                        completion(response)
                    } catch {
                        print(error)
                    }
                }
            }, failure: {
                result in print(result)
            })
        }
    }
    
    func getTopRated(completion: @escaping (MovieList?) -> Void) {
        if let url = URL(string: movieBaseUrl + nowPlayingQuery + APIKey + "&page=" + String(topRatedMoviesPageNumber) + region + USRegion){
            let urlRequest = URLRequest(url: url)
            self.getRequest(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(MovieList.self, from: data)
                        self.topRatedMoviesPageNumber += 1
                        completion(response)
                    } catch {
                        print(error)
                    }
                }
            }, failure: {
                result in print(result)
            })
        }
    }
    
    func getMovieDetailAt(_ movieId: Int, completion: @escaping (MovieDetail?) -> Void) {
        let movieIdQuery = "\(movieId)?"
        if let url = URL(string: movieBaseUrl + movieIdQuery + APIKey + "&append_to_response=videos,images" ) {
            let urlRequest = URLRequest(url: url)
            self.getRequest(urlRequest: urlRequest, success: {
                data in
                if let data = data {
                    do {
                        var movieResponse = try JSONDecoder().decode(MovieDetail.self, from: data)
                        completion(movieResponse)
                        
                    } catch {
                        print(error)
                    }
                }},
        failure: {
            results in print(results)
            })
        }
    }
    
    func getMoviePosterImagesAt(_ posterPath: String?, completion: @escaping (Data?) -> Void) {
        if let posterPath = posterPath {
            if let posterPathUrl = URL(string: tmdbImageBaseUrl + posterPath) {
                self.getRequest(urlRequest: URLRequest(url: posterPathUrl), success:{
                    response in
                    completion(response)
                    
                }, failure:{ response in
                    print(response)
                })
            }
        }
    }
    
    
}
