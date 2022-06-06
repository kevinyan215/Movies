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
    
    var movieGluApiCall = 0
    
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
                                completion(data,error)
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
                                let response2 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

                                let response = try JSONDecoder().decode(decodingType.self, from: data)
//                                print(response)
                                success(response)
                            } catch {
                                failure(error)
                            }
                        }
//                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func logoutUser(success: @escaping (Decodable?) -> Void, failure: @escaping (Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: APIKeyValue)]
        var urlComps = URLComponents(string: theMovieDBBaseURL + authentication + "session?")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonDict = ["session_id": getSessionId()]
        do {
            let json = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            urlRequest.httpBody = json
        } catch {
            
        }
        self.request(with: urlRequest, decodingType: DeleteSessionResponse.self, success: success, failure: failure)
        
    }
    
    func getMovieStateFor(movieId: Int, success: @escaping (Decodable?) -> Void, failure: @escaping (Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: APIKeyValue), URLQueryItem(name: "session_id", value: getSessionId()), URLQueryItem(name: "movie_id", value: String(movieId))]
        var urlComps = URLComponents(string: theMovieDBBaseURL + movie + "\(movieId)/account_states?")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        self.request(with: URLRequest(url: url), decodingType: MovieAccountState.self, success: success, failure: failure)
        
    }
    
    func postFavoriteFor(mediaId: Int, onFavoriteList: Bool, success: @escaping (Decodable?) -> Void, failure: @escaping (Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: APIKeyValue), URLQueryItem(name: "session_id", value: getSessionId())]
        var urlComps = URLComponents(string: theMovieDBBaseURL + "account/\(getAccountId())/favorite?")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonDict:[String:Any] = ["media_type": "movie", "media_id": mediaId, "favorite": onFavoriteList]
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            request.httpBody = data
        } catch {
            
        }

        self.request(with: request, decodingType: AccountResponse.self, success: success, failure: failure)
    }
    
    func postWatchListFor(mediaId: Int, onWatchList:Bool, success: @escaping (Decodable?) -> Void, failure: @escaping (Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: APIKeyValue), URLQueryItem(name: "session_id", value: getSessionId())]
        var urlComps = URLComponents(string: theMovieDBBaseURL + "account/\(getAccountId())/watchlist?")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonDict:[String:Any] = ["media_type": "movie", "media_id": mediaId, "watchlist": onWatchList]
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
            request.httpBody = data
        } catch {
            
        }

        self.request(with: request, decodingType: AccountResponse.self, success: success, failure: failure)
    }
    
    func getFavoritesListFor(sessionId: String, pageNumber: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: APIKeyValue),
                          URLQueryItem(name: "language", value: "en-US"),
                          URLQueryItem(name: "page", value: String(pageNumber)),
                          URLQueryItem(name: "session_id", value: sessionId)]
        var urlComps = URLComponents(string: theMovieDBBaseURL + "account/\(getAccountId())/favorite/movies?")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return  }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)
    }
    
    func getWatchListFor(sessionId: String, pageNumber: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: APIKeyValue),
                          URLQueryItem(name: "language", value: "en-US"),
                          URLQueryItem(name: "page", value: String(pageNumber)),
                          URLQueryItem(name: "session_id", value: sessionId)]
        var urlComps = URLComponents(string: theMovieDBBaseURL + "account/\(getAccountId())/watchlist/movies?")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return  }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)
    }
    
    func getAccountDetailsWith(sessionId: String, success: @escaping (Decodable?) -> Void, failure: @escaping (Error?) -> Void) {
        let queryItems = [URLQueryItem(name: "api_key", value: APIKeyValue), URLQueryItem(name: "session_id", value: sessionId)]
        var urlComps = URLComponents(string: theMovieDBBaseURL + "account?")
        urlComps?.queryItems = queryItems
        if let url = urlComps?.url {
            self.request(with: URLRequest(url: url), decodingType: Account.self, success: success, failure: failure)
        }
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
        let queryItems = [URLQueryItem(name: "page", value: String(pageNumber)), URLQueryItem(name: "api_key", value: APIKeyValue), URLQueryItem(name: "region", value: "US")]
        var urlComps = URLComponents(string: movieBaseUrl + popularMovieQuery)
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)
        }
    
    func getNowPlayingMoviesWith(pageNumber: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        let queryItems = [URLQueryItem(name: "page", value: String(pageNumber)), URLQueryItem(name: "api_key", value: APIKeyValue), URLQueryItem(name: "region", value: "US")]
        var urlComps = URLComponents(string: movieBaseUrl + nowPlayingQuery)
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)
    }
    
    
    func getUpcomingMoviesWith(pageNumber: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        let queryItems = [URLQueryItem(name: "page", value: String(pageNumber)), URLQueryItem(name: "api_key", value: APIKeyValue), URLQueryItem(name: "region", value: "US")]
        var urlComps = URLComponents(string: movieBaseUrl + upcomingQuery)
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)

    }
    
    func getTopRatedWith(pageNumber: Int, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        let queryItems = [URLQueryItem(name: "page", value: String(pageNumber)), URLQueryItem(name: "api_key", value: APIKeyValue), URLQueryItem(name: "region", value: "US")]
        var urlComps = URLComponents(string: movieBaseUrl + topRatedQuery)
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        self.request(with: URLRequest(url: url), decodingType: MovieList.self, completionHandler: completion)
    }
    
    func getSimilarMoviesFor(movieId: Int, success: @escaping (Decodable?) -> Void, failure: @escaping (Error?) -> Void) {
        let movieIdQuery = "\(movieId)/"
        guard let url = URL(string: movieBaseUrl + movieIdQuery + "similar?" + APIKey) else { return }
        let urlRequest = URLRequest(url: url)
        self.request(with: urlRequest, decodingType: MovieList.self, success: success, failure: failure)
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
    
    func getCastDetails(creditId: String, completionHandler completion: @escaping (Decodable?, Error?) -> Void) {
        let queryItems = [ URLQueryItem(name: "api_key", value: APIKeyValue)]
        let creditIdQueryString = creditId + "?"
        var urlComps = URLComponents(string: theMovieDBBaseURL + credit + creditIdQueryString)
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        self.request(with: URLRequest(url: url), decodingType: CastDetails.self, completionHandler: completion)
    }
    
    func searchMovieDetails(searchString: String,
                            success: @escaping (Decodable?) -> Void,
                            failure: @escaping (Error?) -> Void) {
        
        let searchTextUrlEncoded = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = movieSearchUrl + query + searchTextUrlEncoded
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        self.request(with: urlRequest, decodingType: SearchResultList.self, success: success, failure: failure)
    }
                                    
                                    
    func getFilmsNowShowing(success: @escaping (Decodable?) -> Void,
                            failure: @escaping (Error?) -> Void) {
        let urlString = "https://api-gate2.movieglu.com/filmsNowShowing/?n=100"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        request.setValue(MovieGluClient, forHTTPHeaderField: "client")
        request.setValue(MovieGluAPIKeyValue, forHTTPHeaderField: "x-api-key")
        request.setValue(MovieGluAuthorization, forHTTPHeaderField: "authorization")
        
        
        request.setValue(MovieGluTerritory, forHTTPHeaderField: "territory") //must change back to US
        request.setValue(MovieGluAPIVersion, forHTTPHeaderField: "api-version")
        request.setValue(latLong, forHTTPHeaderField: "geolocation")
        request.setValue(deviceDateTime, forHTTPHeaderField: "device-datetime")
        
        self.request(with: request, decodingType: FilmResponse.self, success: success, failure: failure)
        movieGluApiCall += 1
        print("movieGluApiCall getFilmsNowShowing: \(movieGluApiCall)")
    }
    

    func getNearbyCinemas(withLatLong latLong: String,
                          numberOfResults number: Int,
                          success: @escaping (Decodable?) -> Void,
                          failure: @escaping (Error?) -> Void) {
    
        let urlString = "https://api-gate2.movieglu.com/cinemasNearby/?n=\(number)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        request.setValue(MovieGluClient, forHTTPHeaderField: "client")
        request.setValue(MovieGluAPIKeyValue, forHTTPHeaderField: "x-api-key")
        request.setValue(MovieGluAuthorization, forHTTPHeaderField: "authorization")
        
        
        request.setValue(MovieGluTerritory, forHTTPHeaderField: "territory") //must change back to US
        request.setValue(MovieGluAPIVersion, forHTTPHeaderField: "api-version")
        request.setValue(latLong, forHTTPHeaderField: "geolocation")
        request.setValue(deviceDateTime, forHTTPHeaderField: "device-datetime")
        
        self.request(with: request, decodingType: CinemaResponse.self, success: success, failure: failure)
        movieGluApiCall += 1
        print("movieGluApiCall getNearbyCinemas: \(movieGluApiCall)")
    }

    func getFilmShowTimes(withFilmId filmId: Int,
                          latLong: String,
                          date: String,
                          numberOfResults: Int,
                          success: @escaping (Decodable?) -> Void,
                          failure: @escaping (Error?) -> Void) {
            
        let queryItems = [URLQueryItem(name: "n", value: "\(numberOfResults)"),
                          URLQueryItem(name: "film_id", value: "\(filmId)"),
                          URLQueryItem(name: "date", value: date) ]
        var urlComps = URLComponents(string: "https://api-gate2.movieglu.com/filmShowTimes/")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        var request = URLRequest(url: url)
        
        request.setValue(MovieGluClient, forHTTPHeaderField: "client")
        request.setValue(MovieGluAPIKeyValue, forHTTPHeaderField: "x-api-key")
        request.setValue(MovieGluAuthorization, forHTTPHeaderField: "authorization")
        
        
        request.setValue(MovieGluTerritory, forHTTPHeaderField: "territory") //must change back to US
        request.setValue(MovieGluAPIVersion, forHTTPHeaderField: "api-version")
        request.setValue(latLong, forHTTPHeaderField: "geolocation")
        request.setValue(deviceDateTime, forHTTPHeaderField: "device-datetime")
        
        self.request(with: request, decodingType: FilmShowTimeResponse.self, success: success, failure: failure)
        movieGluApiCall += 1
        print("movieGluApiCall, getFilmShowTimes: \(movieGluApiCall)")
    }
    
    func getCinemaDetails(withCinemaId cinemaId: Int,
                          latLong: String,
                          success: @escaping (Decodable?) -> Void,
                          failure: @escaping (Error?) -> Void) {
            
        let queryItems = [URLQueryItem(name: "cinema_id", value: "\(cinemaId)")]
        var urlComps = URLComponents(string: "https://api-gate2.movieglu.com/cinemaDetails/")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        var request = URLRequest(url: url)
        
        request.setValue(MovieGluClient, forHTTPHeaderField: "client")
        request.setValue(MovieGluAPIKeyValue, forHTTPHeaderField: "x-api-key")
        request.setValue(MovieGluAuthorization, forHTTPHeaderField: "authorization")
        
        
        request.setValue(MovieGluTerritory, forHTTPHeaderField: "territory") //must change back to US
        request.setValue(MovieGluAPIVersion, forHTTPHeaderField: "api-version")
        request.setValue(latLong, forHTTPHeaderField: "geolocation")
        request.setValue(deviceDateTime, forHTTPHeaderField: "device-datetime")
        
        self.request(with: request, decodingType: Cinema.self, success: success, failure: failure)
        movieGluApiCall += 1
        print("movieGluApiCall, getCinemaDetails: \(movieGluApiCall)")
    }
    
    func getCinemaShowTimes(cinemaId: Int,
                            filmId: Int,
                            date: String,
                            success: @escaping (Decodable?) -> Void,
                            failure: @escaping (Error?) -> Void) {
        let queryItems = [URLQueryItem(name: "cinema_id", value: "\(cinemaId)"),
                          URLQueryItem(name: "film_id", value: "\(filmId)"),
                          URLQueryItem(name: "date", value: date) ]
        var urlComps = URLComponents(string: "https://api-gate2.movieglu.com/cinemaShowTimes/")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        var request = URLRequest(url: url)
        
        request.setValue(MovieGluClient, forHTTPHeaderField: "client")
        request.setValue(MovieGluAPIKeyValue, forHTTPHeaderField: "x-api-key")
        request.setValue(MovieGluAuthorization, forHTTPHeaderField: "authorization")
        
        request.setValue(MovieGluTerritory, forHTTPHeaderField: "territory") //must change back to US
        request.setValue(MovieGluAPIVersion, forHTTPHeaderField: "api-version")
        request.setValue(latLong, forHTTPHeaderField: "geolocation")
        request.setValue(deviceDateTime, forHTTPHeaderField: "device-datetime")
        
        self.request(with: request, decodingType: CinemaShowTimeResponse.self, success: success, failure: failure)
        movieGluApiCall += 1
        print("movieGluApiCall, getCinemaShowTimes: \(movieGluApiCall)")
    }
    
    func purchaseMovieTicket(cinemaId: Int,
                             filmId: Int,
                             date: String,
                             time: String,
                             success: @escaping (Decodable?) -> Void,
                             failure: @escaping (Error?) -> Void ) {
        
        let queryItems = [URLQueryItem(name: "cinema_id", value: "\(cinemaId)"),
                          URLQueryItem(name: "film_id", value: "\(filmId)"),
                          URLQueryItem(name: "date", value: date),
                          URLQueryItem(name: "time", value: time)]
        var urlComps = URLComponents(string: "https://api-gate2.movieglu.com/purchaseConfirmation/?")
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        var request = URLRequest(url: url)
        
        request.setValue(MovieGluClient, forHTTPHeaderField: "client")
        request.setValue(MovieGluAPIKeyValue, forHTTPHeaderField: "x-api-key")
        request.setValue(MovieGluAuthorization, forHTTPHeaderField: "authorization")
        
        request.setValue(MovieGluTerritory, forHTTPHeaderField: "territory") //must change back to US
        request.setValue(MovieGluAPIVersion, forHTTPHeaderField: "api-version")
        request.setValue(latLong, forHTTPHeaderField: "geolocation")
        request.setValue(deviceDateTime, forHTTPHeaderField: "device-datetime")
        
        self.request(with: request, decodingType: PurchaseConfirmation.self, success: success, failure: failure)
        movieGluApiCall += 1
        print("movieGluApiCall, purchaseMovieTicket: \(movieGluApiCall)")
    }
}
