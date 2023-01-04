//
//  TodayWeatherCollectionViewManager.swift
//  Weather map
//
//  Created by Oleksii on 04.01.2023.
//

import Foundation
import UIKit

class TodayWeatherCollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let items: [ShortWeatherData]
    private let rowHeight: CGFloat
    
    private weak var collectionView: UICollectionView?
    
    init(items: [ShortWeatherData], rowHeight: CGFloat, collectionView: UICollectionView) {
        
        self.items = items
        self.rowHeight = rowHeight

        self.collectionView = collectionView
        
        super.init()
        
        collectionView.register(TodayWeatherCollectionViewCell.self,
                                forCellWithReuseIdentifier: TodayWeatherCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: TodayWeatherCollectionViewCell .identifier,
                                 for: indexPath) as? TodayWeatherCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        cell.setup(with: items[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        .init(width: collectionView.bounds.width / items.count.cgFloat, height: rowHeight)
    }
}
