//
//  BaseHeaderCollectionController.swift
//  socialApp
//
//  Created by Daryl on 2021/7/17.
//

import UIKit

class BaseHeaderCollectionController<T: BaseCollectionCell<U, V>, U: Decodable, V:ViewModel<U> , H: BaseReusableView<I, J>, I: Decodable, J: ViewModel<I>>: BaseCollectionController<T, U, V> {
    
    let supplementaryHeaderId = "supplementaryHeaderId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(H.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: supplementaryHeaderId)
    }
    
    var headerItem: J?
    
    func setupHeader(header: H) {}
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryHeaderId, for: indexPath) as! H
            setupHeader(header: header)
            return header
        }
        
        return UICollectionReusableView()
    }
}
