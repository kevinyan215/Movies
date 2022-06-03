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
		return label
	}()

    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: 75, height: 50)
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
        self.contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cinemaTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cinemaTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            cinemaTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            cinemaTitle.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: self.cinemaTitle.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func getShowTimes(success: @escaping () -> Void) {
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
            print($0)
        } )
    }
}

extension NearbyCinemaTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cinemaShowTimes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CinemaShowTimeCollectionViewCellIdentifier, for: indexPath) as? CinemaShowTimeCollectionViewCell {
            cell.movieStartTimeButton.setTitle(self.cinemaShowTimes?[indexPath.row].start_time, for: .normal)
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
                self?.parent?.navigationController?.present(vc, animated: true, completion: nil)
            }
        }, failure: {
            print($0)
        })
    }
}

//extension NearbyCinemaTableViewCell : UICollectionViewDelegate {
//}
