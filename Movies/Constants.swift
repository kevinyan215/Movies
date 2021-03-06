//
//  Constants.swift
//  Movies
//
//  Created by Kevin Yan on 4/25/19.
//  Copyright © 2019 Kevin Yan. All rights reserved.
//

import Foundation
let tmdbImageBaseUrl = "https://image.tmdb.org/t/p/w780"

let theMovieDBBaseURL = "https://api.themoviedb.org/3/"
let movieBaseUrl = theMovieDBBaseURL + "movie/"
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

//let castCrewQuery =
let multiSearchUrl = multiSearchBaseUrl + APIKey
let movieSearchUrl = movieSearchBaseUrl + APIKey
let APIKey = "api_key=\(APIKeyValue)"
let APIKeyValue = "608b8e34a89c818571631096e34773a3"
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
