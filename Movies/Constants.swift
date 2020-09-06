//
//  Constants.swift
//  Movies
//
//  Created by Kevin Yan on 4/25/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import Foundation

let APIKeyValue = "608b8e34a89c818571631096e34773a3"

let theMovieDBBaseURL = "https://api.themoviedb.org/3/"
let movieBaseUrl = theMovieDBBaseURL + movie
let requestNewTokenUrl = theMovieDBBaseURL + authentication + token + new + APIKey
let validateWithLoginUrl = theMovieDBBaseURL + authentication + token + validateWithLogin
let newSessionUrl = theMovieDBBaseURL + authentication + session + new
let authentication = "authentication/"
let session = "session/"
let token = "token/"
let new = "new?"
let validateWithLogin = "validate_with_login?"
let movie = "movie/"
let popularMovieQuery = "popular?"
let nowPlayingQuery = "now_playing?"
let upcomingQuery = "upcoming?"
let topRatedQuery = "top_rated?"
let searchQuery = "search/"
let query = "&query="
let region = "&region="
let USRegion = "US"
private let multiSearchBaseUrl = theMovieDBBaseURL + searchQuery + "multi?"
private let movieSearchBaseUrl = theMovieDBBaseURL + searchQuery + "movie?"
let tmdbImageBaseUrl = "https://image.tmdb.org/t/p/w500"

//let castCrewQuery =
let multiSearchUrl = multiSearchBaseUrl + APIKey
let movieSearchUrl = movieSearchBaseUrl + APIKey
let APIKey = "api_key=\(APIKeyValue)"
let YoutubeWatchUrl = "https://www.youtube.com/embed/"

let movieCollectionViewCellIdentifier = "MovieCollectionViewCellIdentifier"
let videoCollectionViewCellIdentifier = "VideoCollectionViewCellIdentifier"
let castCrewCollectionViewCellIdentifier = "CastCrewCollectionViewCellIdentifier"
let SearchResultsTableViewCellIdentifier = "SearchResultsTableViewCellIdentifier"
let PopularMoviesCellId = "PopularMoviesCellId"
let MovieTabBarCellId = "MovieTabBarCellId"
let NowPlayingMoviesCellId = "NowPlayingMoviesCellId"
let TopRatedMoviesCellId = "TopRatedMoviesCellId"
let UpcomingMoviesCellId = "UpcomingMoviesCellId"

let AccountUserNameTableViewCellId = "AccountUserNameTableViewCellId"
let AccountSignOutTableViewCellId = "AccountSignOutTableViewCellId"

let sessionIdIdentifier = "sessionIdIdentifier"
let accountIdIdentifier = "accountIdIdentifier"
let accountUsernameIdentifier = "accountUsernameIdentifier"
