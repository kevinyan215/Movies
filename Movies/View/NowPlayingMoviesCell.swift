//
//  NowPlayingMoviesCell.swift
//  Movies
//
//  Created by Kevin Yan on 8/11/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class NowPlayingMoviesCell : MovieTabBarCell {
    override func getMovies() {
//        super.getMovies()
//        networkManager.getNowPlayingMoviesWith(pageNumber: pageNumber, completionHandler: getMovieClosure)
        
        if true {
            guard let data = readLocalFile(forName: "NowShowingFilmsSandbox") else { return }
            let parsedData = parse(decodingType: FilmResponse.self, jsonData: data)
            self.searchMovieDetails(data: parsedData)
                    
        } else {
            networkManager.getFilmsNowShowing(success: {
                [weak self] data in
//                print(data)
                
                self?.searchMovieDetails(data: data)
            }, failure: {
                print($0)
            })
        }
    }
    
    func searchMovieDetails(data: Decodable?) {
        guard let filmResponse = data as? FilmResponse, let films = filmResponse.films else { return }
        for film in films {
            guard let filmName = film.film_name else { return }
            networkManager.searchMovieDetails(searchString: filmName, success: {
               [weak self] response in
                guard let searchResponseList = response as? SearchResultList, let firstMovieFound = searchResponseList.results.first, let id = firstMovieFound?.id else { return }
                networkManager.getMovieDetailAt(id, completionHandler:  {
                    movieResponse, error in
                    guard var movieResponse = movieResponse as? MovieDetail else {return}
                    
                    networkManager.getMoviePosterImagesAt(movieResponse.poster_path, completion: {
                        data,error  in
                        movieResponse.poster_image = data
                        movieResponse.film_id = film.film_id
                        self?.movies.append(movieResponse)
                        DispatchQueue.main.async {
                            self?.moviesCollectionView.reloadData()
                            self?.isWaiting = false
                        }
                    })

                })
                
                    }, failure: {
                        print($0)
                    })
        }
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("overrode here")
    }
}
