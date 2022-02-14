//
//  HobbySearchingViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/12.
//

import UIKit
import SnapKit
import Toast
import JGProgressHUD

final class HobbySearchingViewController: BaseViewController {
    
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
    let progress = JGProgressHUD()
    let nearHobbyLabel = UILabel()
    let nearHobbyCollectionView = TagDynamicHeightCollectionView()
    let wantHobbyLabel = UILabel()
    let wantHobbyCollectionView = TagDynamicHeightCollectionView()
    let searchButton = FillButton()
    
    var searchedFriends: SearchedFriends?
    var lat = 0.0
    var long = 0.0
    var region = 0
    var fromRecommend = [String](){
        didSet{
            nearHobbyCollectionView.reloadData()
        }
    }
    var fromHF = [String](){
        didSet{
            nearHobbyCollectionView.reloadData()
        }
    }
    var wantHobbies = [String](){
        didSet{
            wantHobbyCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        navigationController?.changeNavigationBar(isClear: true)
        backConfigure()
        navigationItem.titleView = searchBar
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
        
        //searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        
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
        searchFriendsServer()
        let vc = NearUserViewController()
        vc.searchedFriends = self.searchedFriends
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchFriendsServer(){
        progress.show(in: view, animated: true)
        
        if wantHobbies.isEmpty{
            wantHobbies += ["Anything"]
        }
        
        ServerService.shared.postRequestFrineds(region: self.region, lat: self.lat, long: self.long, hobby: self.wantHobbies) { statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                DispatchQueue.main.async {
                    print("성공~")
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.searchFriendsServer()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            default:
                print("ERROR: ", statusCode)
            }
        }
        self.progress.dismiss(animated: true)
        
    }
    
}


extension HobbySearchingViewController: UITextFieldDelegate {
    //리턴키
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else{ return true }
        let texts = text.split(separator: " ").map{String($0)} //띄어쓰기 자르기
        
        //공백일 경우
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.view.makeToast("최소 한 자 이상, 최대 8글자까지 작성 가능합니다", duration: 3.0, position: .top)
            return true
        }
        // 8개 넘을 경우
        else if wantHobbies.count + texts.count > 8{
            self.view.makeToast("취미를 더 이상 추가할 수 없습니다 (8개)", duration: 3.0, position: .top)
            return true
        }
        
        for text in texts {
            //띄어쓰기 글자중 8글자 넘는게 있는지 판단
            if text.count > 8{
                self.view.makeToast("각 취미 최소 한 자 이상, 최대 8글자까지 작성 가능합니다", duration: 3.0, position: .top)
                return true
            }
            //띄어쓰기 글자중 이미 있는게 있는지 판단
            else if wantHobbies.contains(text){
                self.view.makeToast("이미 등록된 취미가 있습니다", duration: 3.0, position: .top)
                return true
            }
        }
        
        wantHobbies += texts
        textField.text = ""
        
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
            //셀 안 삭제 버튼 액션 클로저로 구현
            //unowned self 를 쓴 이유는 retain 싸이클을 방지하기 위해서 사용
            cell.delete = { [unowned self] in
                if let selecttIndex = wantHobbies.firstIndex(of: wantHobbies[indexPath.row]) {
                    wantHobbies.remove(at: selecttIndex)
                }
            }
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        if collectionView == nearHobbyCollectionView {
            if wantHobbies.count >= 8 {
                self.view.makeToast("취미를 더 이상 추가할 수 없습니다 (8개)", duration: 3.0, position: .top)
                return
            }
            if indexPath.section == 0{
                if let selecttIndex = fromRecommend.firstIndex(of: fromRecommend[row]) {
                    wantHobbies += [fromRecommend[row]]
                    fromRecommend.remove(at: selecttIndex)
                }
            }
            else{
                if let selecttIndex = fromHF.firstIndex(of: fromHF[row]) {
                    wantHobbies += [fromHF[row]]
                    fromHF.remove(at: selecttIndex)
                }
            }
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
    var delete : (() -> ()) = {}
    
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
        let removeAction = UITapGestureRecognizer(target: self, action: #selector(removeButtonClicked))
        removeButton.isUserInteractionEnabled = true
        removeButton.addGestureRecognizer(removeAction)
        
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
    
    @objc func removeButtonClicked(){
        delete()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
