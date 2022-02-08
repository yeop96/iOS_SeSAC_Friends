//
//  MyInfromationViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/29.
//

import UIKit
import SnapKit

class MyInformationViewController: BaseViewController {
    let tableView = UITableView()
    let settings = [["notice", "공지사항"], ["faq","자주 묻는 질문"], ["qna", "1:1 문의"] ,["setting_alarm", "알림 설정"], ["permit", "이용 약관"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        navigationController?.changeNavigationBar(isClear: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InformationListTableViewCell.self, forCellReuseIdentifier: InformationListTableViewCell.identifier)
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    override func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension MyInformationViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as? ProfileTableViewCell else{
                return UITableViewCell()
            }
            cell.nameLabel.text = UserData.nickName
            
            return cell
        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationListTableViewCell.identifier) as? InformationListTableViewCell else{
                return UITableViewCell()
            }
            let row = indexPath.row
            cell.iconImageView.image = UIImage(named: settings[row][0])
            cell.titleLabel.text = settings[row][1]
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 96 : 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let nextViewController = MyInformationManagementViewController()
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
}

class ProfileTableViewCell: UITableViewCell{
    static let identifier = "ProfileTableViewCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 13
        return stackView
    }()
    let separatorVeiw = UIView()
    let proefileImageView = UIImageView()
    let nameLabel = UILabel()
    let arrowImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .white
        
        contentView.addSubview(separatorVeiw)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(proefileImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(arrowImageView)
        
        separatorVeiw.backgroundColor = .gray2
        proefileImageView.image = UIImage(named: "profile_img")
        nameLabel.font = UIFont().Title1_M16
        nameLabel.textAlignment = .left
        nameLabel.textColor = .black
        arrowImageView.image = UIImage(named: "more_arrow")

        separatorVeiw.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(separatorVeiw.snp.bottom).offset(23)
            make.bottom.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        proefileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
        }
        arrowImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}

class InformationListTableViewCell: UITableViewCell{
    static let identifier = "InformationListTableViewCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    let separatorVeiw = UIView()
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .white
        
        contentView.addSubview(separatorVeiw)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        
        separatorVeiw.backgroundColor = .gray2
        iconImageView.tintColor = .black
        titleLabel.font = UIFont().Title2_R16
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black

        separatorVeiw.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
            make.height.equalTo(1)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(separatorVeiw.snp.bottom).offset(23)
            make.bottom.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
