//
//  MovieTabBar.swift
//  Movies
//
//  Created by Kevin Yan on 8/8/20.
//  Copyright © 2020 Kevin Yan. All rights reserved.
//

import UIKit

class MovieTabBar: UIView {
    
    lazy var menuTabsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.gray
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    var tabSelections:[String]
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    var movieCollectionViewController: MovieCollectionViewController?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/CGFloat(tabSelections.count)).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    init(tabSelections: [String], frame: CGRect) {
        self.tabSelections = tabSelections
        super.init(frame: frame)
        menuTabsCollectionView.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
        setupView()
        setupHorizontalBar()

        let selectedIndexPath = IndexPath(item: 0, section: 0)
        menuTabsCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom)
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(menuTabsCollectionView)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            menuTabsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            menuTabsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            menuTabsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            menuTabsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MovieTabBar : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabSelections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? MenuCell {
//            cell.backgroundColor = UIColor.blue
            cell.label.text = tabSelections[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MovieTabBar : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieCollectionViewController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
}

extension MovieTabBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(tabSelections.count), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
