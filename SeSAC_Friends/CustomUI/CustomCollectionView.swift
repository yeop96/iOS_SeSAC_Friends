//
//  CustomCollectionView.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/13.
//

import UIKit

class TagDynamicHeightCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout){
        super.init(frame: frame, collectionViewLayout: layout)
        
        //isScrollEnabled = false
        collectionViewLayout = layout
        backgroundColor = .white
    }
    
    convenience init() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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


// UICollectionViewCell 최대한 왼쪽정렬시켜주는 flowLayout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 재정의 오버라이드 메소드 임으로 리턴값으로 layout 속성값들을 받습니다.
        let attributes = super.layoutAttributesForElements(in: rect)
        
        // contentView의 left 여백
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0 // cell라인의 y값의 디폴트값
        attributes?.forEach { layoutAttribute in
            // cell일경우
            if layoutAttribute.representedElementCategory == .cell {
                // 한 cell의 y 값이 이전 cell들이 들어갔더 line의 y값보다 크다면
                // 디폴트값을 -1을 줬기 때문에 처음은 무조건 발동, x좌표 left에서 시작
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                // cell의 x좌표에 leftMargin값 적용해주고
                layoutAttribute.frame.origin.x = leftMargin
                // cell의 다음값만큼 cellWidth + minimumInteritemSpacing + 해줌
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                // cell의 위치값과 maxY변수값 중 최대값 넣어줌(라인 y축값 업데이트)
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
