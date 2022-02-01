//
//  MyInfromationViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/29.
//

import UIKit
import SnapKit
import SwiftUI

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationListTableViewCell.identifier) as? InformationListTableViewCell else{
            return UITableViewCell()
        }
        let row = indexPath.row
        cell.iconImageView.image = UIImage(named: settings[row][0])
        cell.titleLabel.text = settings[row][1]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class ProfileTableViewCell: UITableViewCell{
    
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
