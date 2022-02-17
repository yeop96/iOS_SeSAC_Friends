//
//  CustomTableViewCell.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/15.
//

import UIKit
import SnapKit

class UserProfileTableViewCell: UITableViewCell{
    static let identifier = "UserProfileTableViewCell"
    
    let profileView = UIView()
    let profileBackImageView = UIImageView()
    let profileUserImageView = UIImageView()
    let matchButton = UIButton()
    
    let profileDetailView = UIView()
    let nickNameLabel = UILabel()
    let titleLabel = UILabel()
    let reputationsView = ReputationButtonsView()
    let wantHobbyLabel = UILabel()
    let wantHobbyCollectionView = TagDynamicHeightCollectionView()
    let reviewTitleLabel = UILabel()
    let reviewLabel = UILabel()
    
    var hobbyData = [String](){
        didSet{
            wantHobbyCollectionView.reloadData()
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setupConstraints()
    }
    
    func configure(){
        self.selectionStyle = .none
        profileView.layer.cornerRadius = 8
        profileView.clipsToBounds = true
        profileBackImageView.image = SesacBackgroundImage(rawValue: 0)?.sesacBackgroundUIImage()
        profileUserImageView.image = SesacImage(rawValue: 0)?.sesacUIImage()
        matchButton.layer.cornerRadius = 8
        matchButton.setTitleColor(.white, for: .normal)
        matchButton.titleLabel?.font = UIFont().Title3_M14
        matchButton.backgroundColor = .error //.success
        
        profileDetailView.layer.cornerRadius = 8
        profileDetailView.layer.borderWidth = 1
        profileDetailView.layer.borderColor = UIColor.gray2.cgColor
        nickNameLabel.font = UIFont().Title1_M16
        nickNameLabel.textColor = .black
        nickNameLabel.textAlignment = .left
        nickNameLabel.text = "이름 구간"
        titleLabel.text = "새싹 타이틀"
        wantHobbyLabel.text = "하고 싶은 취미"
        wantHobbyCollectionView.delegate = self
        wantHobbyCollectionView.dataSource = self
        wantHobbyCollectionView.register(HobbyCell.self, forCellWithReuseIdentifier: HobbyCell.identifier)
        reviewTitleLabel.text = "새싹 리뷰"
        reviewLabel.text = "첫 리뷰를 기다리는 중이에요!"
        [titleLabel, wantHobbyLabel, reviewTitleLabel].forEach {
            $0.font = UIFont().Title6_R12
            $0.textColor = .black
            $0.textAlignment = .left
        }
        reviewLabel.font = UIFont().Body3_R14
        reviewLabel.textColor = .gray6
        reviewLabel.textAlignment = .left
    }
    
    func setupConstraints(){
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(194)
        }
        profileView.addSubview(profileBackImageView)
        profileView.addSubview(profileUserImageView)
        profileView.addSubview(matchButton)
        profileBackImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        profileUserImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(19)
            make.size.equalTo(184)
        }
        matchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(profileDetailView)
        profileDetailView.addSubview(nickNameLabel)
        profileDetailView.addSubview(titleLabel)
        profileDetailView.addSubview(reputationsView)
        profileDetailView.addSubview(wantHobbyLabel)
        profileDetailView.addSubview(wantHobbyCollectionView)
        profileDetailView.addSubview(reviewTitleLabel)
        profileDetailView.addSubview(reviewLabel)
        
        profileDetailView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom).inset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileDetailView.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(26)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        reputationsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        wantHobbyLabel.snp.makeConstraints { make in
            make.top.equalTo(reputationsView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        wantHobbyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(wantHobbyLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        reviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(wantHobbyCollectionView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserProfileTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hobbyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCell.identifier, for: indexPath) as? HobbyCell else {
            return UICollectionViewCell()
        }
        
        cell.tagLabel.text = hobbyData[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        
        label.font = UIFont().Title4_R14
        label.text = hobbyData[indexPath.item]
        label.sizeToFit()
        
        let size = label.frame.size
        
        return CGSize(width: size.width + 34, height: size.height + 14)
        
    }

}


class HobbyCell: UICollectionViewCell {
    static let identifier = "HobbyCell"
    let tagLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutIfNeeded()
        configure()
        setConstraint()
    }
    func configure(){
        tagLabel.font = UIFont().Title4_R14
        tagLabel.textColor = .black
        contentView.layer.borderColor = UIColor.gray4.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
    }
    func setConstraint() {
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
