//
//  Constants.swift
//  Movies
//
//  Created by Kevin Yan on 4/25/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import Foundation

let APIKeyValue = "608b8e34a89c818571631096e34773a3"

//sandbox cvstest
let MovieGluAPIKeyValue = "X2HHxAGa8uAolhC2JslK60cDRYTFsAE2QphLN023"
let MovieGluAuthorization = "Basic SU1EQl9YWDp6SW9YeG53TFQ5QWE="
let MovieGluTerritory = "XX" //sandbox
let MovieGluClient = "IMDB" //may need to change if get new API key
let NowShowingFilmsSandbox = "NowShowingFilmsSandbox"
let sandboxEnabled = true

let MovieGluAPIVersion = "v200"

//prod cvstest
//let MovieGluAuthorization = "Basic TU9WSV8xMjA6M0NOb0hGcG5VenM5"
//let MovieGluAPIKeyValue = "0cc94yDFOk5UfEetE0hvr6Q9i4R8bj8K6O0JwUE7"
//let MovieGluTerritory = "US"
//let MovieGluClient = "MOVI_120"
//let NowShowingFilmsSandbox = "NowShowingFilmsProd"

//let latLong = "37.77;-122.41"
let latLong = "-22.0;14.0"

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

let credit = "credit/"

let multiSearchUrl = multiSearchBaseUrl + APIKey
let movieSearchUrl = movieSearchBaseUrl + APIKey
let APIKey = "api_key=\(APIKeyValue)"
let YoutubeEmbedUrl = "https://www.youtube.com/embed/"
let YoutubeWatchUrl = "https://www.youtube.com/watch?v="

let movieCollectionViewCellIdentifier = "MovieCollectionViewCellIdentifier"
let videoCollectionViewCellIdentifier = "VideoCollectionViewCellIdentifier"
let castCrewCollectionViewCellIdentifier = "CastCrewCollectionViewCellIdentifier"
let SearchResultsTableViewCellIdentifier = "SearchResultsTableViewCellIdentifier"
let SimilarMovieCollectionViewCellIdentifer = "SimilarMovieCollectionViewCellIdentifer"
let PopularMoviesCellId = "PopularMoviesCellId"
let MovieTabBarCellId = "MovieTabBarCellId"
let NowPlayingMoviesCellId = "NowPlayingMoviesCellId"
let TopRatedMoviesCellId = "TopRatedMoviesCellId"
let UpcomingMoviesCellId = "UpcomingMoviesCellId"
let NearbyCinemaTableViewCellIdentifier = "NearbyCinemaTableViewCellIdentifier"
let CinemaShowTimeCollectionViewCellIdentifier = "CinemaShowTimeCollectionViewCellIdentifier"

let AccountUserNameTableViewCellId = "AccountUserNameTableViewCellId"
let AccountSignOutTableViewCellId = "AccountSignOutTableViewCellId"

let sessionIdIdentifier = "sessionIdIdentifier"
let accountIdIdentifier = "accountIdIdentifier"
let accountUsernameIdentifier = "accountUsernameIdentifier"

let NearbyCinemasAnnotationViewIdentifier = "NearbyCinemasAnnotationViewIdentifier"

let deviceDateTime = getCurrentTimeInISO8601()

