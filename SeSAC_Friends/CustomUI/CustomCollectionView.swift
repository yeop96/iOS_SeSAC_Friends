//
//  CustomCollectionView.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/13.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
        
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
