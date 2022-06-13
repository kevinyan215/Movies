//
//  NearbyCinemaTableViewCell.swift
//  Movies
//
//  Created by Kevin Yan on 5/30/22.
//  Copyright © 2022 Kevin Yan. All rights reserved.
//

import UIKit

class NearbyCinemaTableViewCell : UITableViewCell {
    var cinemaId: Int?
    var filmId: Int?
    var cinemaShowTimes: [Time]?
    
    var parent: UIViewController?
	let cinemaTitle: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
		return label
	}()

    let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 50)
        collectionViewFlowLayout.scrollDirection = .horizontal
        return collectionViewFlowLayout
        
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.register(CinemaShowTimeCollectionViewCell.self, forCellWithReuseIdentifier: CinemaShowTimeCollectionViewCellIdentifier)
        return collectionView
    }()

 	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupConstraints()
//        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(cinemaTitle)
        self.addSubview(distanceLabel)
        self.contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cinemaTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cinemaTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            cinemaTitle.heightAnchor.constraint(equalToConstant: 50),
            cinemaTitle.trailingAnchor.constraint(equalTo: distanceLabel.leadingAnchor, constant: -10),
            
            distanceLabel.centerYAnchor.constraint(equalTo: self.cinemaTitle.centerYAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            distanceLabel.widthAnchor.constraint(equalToConstant: 120),
            distanceLabel.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: self.cinemaTitle.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func getShowTimes(success: @escaping () -> Void, failure: @escaping (Int?) -> Void) {
        guard let cinemaId = cinemaId, let filmId = filmId else {
            return
        }

        NetworkingManager.shared.getCinemaShowTimes(cinemaId: cinemaId, filmId: filmId, date: getCurrentDate(), success: {
            [weak self] response in
            guard let response = response as? CinemaShowTimeResponse else { return }
            self?.cinemaShowTimes = response.films?.first?.showings?.Standard?.times
            success()
//            print(response)
        }, failure: {
            failure(self.cinemaId)
            print($0)
        } )
    }
}

extension NearbyCinemaTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cinemaShowTimes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cinemaShowTimes = self.cinemaShowTimes, indexPath.row <= cinemaShowTimes.count-1 else { return UICollectionViewCell() }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CinemaShowTimeCollectionViewCellIdentifier, for: indexPath) as? CinemaShowTimeCollectionViewCell, let startTime = self.cinemaShowTimes?[indexPath.row].start_time {
            let dateTime = getDateFromString(date: startTime, withFormat: "HH:mm")
            guard let dateTime = dateTime else {
                return UICollectionViewCell()
            }
            let startTimeString = getStringFromDate(dateTime, withFormat: "h:mm a")
            cell.movieStartTimeButton.setTitle(startTimeString, for: .normal)
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}

extension NearbyCinemaTableViewCell : MovieStartTimeButtonDelegate {
    func moviesStartTimeButtonClicked(cell: CinemaShowTimeCollectionViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell),
                let cinemaId = self.cinemaId,
                let filmId = self.filmId,
                let time = cinemaShowTimes?[indexPath.row].start_time
        else { return }
        NetworkingManager.shared.purchaseMovieTicket(cinemaId: cinemaId, filmId: filmId, date: getCurrentDate(), time: time, success: {
            [weak self] response in
            guard let response = response as? PurchaseConfirmation else { return }
            DispatchQueue.main.async {
                let vc = PurchaseMovieTicketWebViewController()
                vc.url = response.url
//                self?.parent?.navigationController?.pushViewController(vc, animated: true)
                self?.parent?.navigationController?.present(vc, animated: true, completion: nil)
            }
        }, failure: {
            print($0)
        })
    }
}

//extension NearbyCinemaTableViewCell : UICollectionViewDelegate {
//}
