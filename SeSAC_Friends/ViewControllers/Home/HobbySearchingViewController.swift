//
//  HobbySearchingViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/12.
//

import UIKit
import SnapKit
import Toast

class HobbySearchingViewController: BaseViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        let placeholderText = "띄어쓰기로 복수 입력이 가능해요"
        searchbar.placeholder = placeholderText
        if let textField = searchbar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .gray1
            let font = UIFont().Title4_R14
            let placeholderAttributedText =  NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.kern: -1.0, NSAttributedString.Key.font: font])
            let attributes =  [NSAttributedString.Key.kern: -1.0,
                               NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
            
            textField.attributedPlaceholder = placeholderAttributedText
            textField.font = UIFont().Title4_R14
            textField.textColor = .black
            textField.defaultTextAttributes = attributes
            textField.returnKeyType = UIReturnKeyType.done
        }
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        searchbar.sizeToFit()
        
        return searchbar
    }()
    let nearHobbyLabel = UILabel()
    let nearHobbyCollectionView = TagDynamicHeightCollectionView()
    let wantHobbyLabel = UILabel()
    let wantHobbyCollectionView = TagDynamicHeightCollectionView()
    let searchButton = FillButton()
    
    var searchedFriends: SearchedFriends?
    var fromRecommend = [String]()
    var fromHF = [String]()
    
    var wantHobbies = [String]()
    var newWantHobbies = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        navigationController?.changeNavigationBar(isClear: true)
        backConfigure()
        navigationItem.titleView = searchBar
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
        
        searchBar.delegate = self
        
        
        nearHobbyLabel.font = UIFont().Title6_R12
        nearHobbyLabel.textColor = .black
        nearHobbyLabel.text = "지금 주변에는"
        
        
        nearHobbyCollectionView.delegate = self
        nearHobbyCollectionView.dataSource = self
        nearHobbyCollectionView.register(NearHobbyCell.self, forCellWithReuseIdentifier: NearHobbyCell.identifier)
        
        
        wantHobbyLabel.font = UIFont().Title6_R12
        wantHobbyLabel.textColor = .black
        wantHobbyLabel.text = "내가 하고 싶은"

        wantHobbyCollectionView.delegate = self
        wantHobbyCollectionView.dataSource = self
        wantHobbyCollectionView.register(WantHobbyCell.self, forCellWithReuseIdentifier: WantHobbyCell.identifier)

        searchButton.setTitle("새싹 찾기", for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        
        fromRecommend = searchedFriends!.fromRecommend
        searchedFriends?.fromQueueDB.forEach({
            fromHF += $0.hf
        })
        searchedFriends?.fromQueueDBRequested.forEach({
            fromHF += $0.hf
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    override func setupConstraints() {
        view.addSubview(nearHobbyLabel)
        view.addSubview(nearHobbyCollectionView)
        view.addSubview(wantHobbyLabel)
        view.addSubview(wantHobbyCollectionView)
        view.addSubview(searchButton)
        
        nearHobbyLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        nearHobbyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nearHobbyLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        wantHobbyLabel.snp.makeConstraints { make in
            make.top.equalTo(nearHobbyCollectionView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        
        wantHobbyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(wantHobbyLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        searchButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
    
    @objc func searchButtonClicked(){
        
    }
    
}


extension HobbySearchingViewController: UISearchBarDelegate {
    //리턴키
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
}

extension HobbySearchingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return collectionView == nearHobbyCollectionView ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == nearHobbyCollectionView{
            return section == 0 ? fromRecommend.count : fromHF.count
        } else {
            return wantHobbies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == nearHobbyCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearHobbyCell.identifier, for: indexPath) as? NearHobbyCell else {
                return UICollectionViewCell()
            }
            if indexPath.section == 0{
                cell.contentView.layer.borderColor = UIColor.error.cgColor
                cell.tagLabel.textColor = .error
                cell.tagLabel.text = fromRecommend[indexPath.item]
            } else{
                cell.contentView.layer.borderColor = UIColor.gray4.cgColor
                cell.tagLabel.textColor = .black
                cell.tagLabel.text = fromHF[indexPath.item]
            }
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WantHobbyCell.identifier, for: indexPath) as? WantHobbyCell else {
                return UICollectionViewCell()
            }
            cell.tagLabel.text = wantHobbies[indexPath.row]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        if collectionView == nearHobbyCollectionView {
            if indexPath.section == 0{
                let label = UILabel()

                label.font = UIFont().Title4_R14
                label.text = fromRecommend[indexPath.item]
                label.sizeToFit()
                
                let size = label.frame.size
                
                return CGSize(width: size.width + 34, height: size.height + 14)
            } else{
                
                let label = UILabel()
                
                label.font = UIFont().Title4_R14
                label.text = fromHF[indexPath.item]
                label.sizeToFit()
                
                let size = label.frame.size
                
                return CGSize(width: size.width + 34, height: size.height + 14)
            }
            
        } else {
            
            let label = UILabel()
            
            label.font = UIFont().Title4_R14
            label.text = wantHobbies[indexPath.item]
            label.sizeToFit()
            
            let size = label.frame.size
            
            return CGSize(width: size.width + 54, height: size.height + 14)
            
        }
    }
}


class NearHobbyCell: UICollectionViewCell {
    static let identifier = "NearHobbyCell"
    
    let tagLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutIfNeeded()
        configure()
        setConstraint()
    }
    func configure(){
        tagLabel.font = UIFont().Title4_R14
        tagLabel.textColor = .gray
        contentView.layer.borderColor = UIColor.gray.cgColor
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

class WantHobbyCell: UICollectionViewCell {
    static let identifier = "WantHobbyCell"
    
    let tagLabel = UILabel()
    let removeButton = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutIfNeeded()
        configure()
        setConstraint()
    }
    func configure(){
        tagLabel.font = UIFont().Title4_R14
        tagLabel.textColor = .green
        removeButton.image = UIImage(named: "close_small")?.withRenderingMode(.alwaysTemplate)
        removeButton.tintColor = .green
        contentView.layer.borderColor = UIColor.green.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
    }
    func setConstraint() {
        contentView.addSubview(tagLabel)
        contentView.addSubview(removeButton)
        tagLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
        removeButton.snp.makeConstraints { make in
            make.leading.equalTo(tagLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
            make.size.equalTo(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
