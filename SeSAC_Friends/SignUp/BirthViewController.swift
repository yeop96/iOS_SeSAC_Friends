//
//  BirthViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/24.
//

import UIKit
import SnapKit
import Toast

class BirthViewController: BaseViewController {
    
    let textLabel = UILabel()
    let dateStackView = UIStackView()
    let yearStackView = UIStackView()
    let monthStackView = UIStackView()
    let dayStackView = UIStackView()
    let yearTextField = InputTextField()
    let monthTextField = InputTextField()
    let dayTextField = InputTextField()
    let yearLabel = UILabel()
    let monthLabel = UILabel()
    let dayLabel = UILabel()
    let nextButton = DisableButton()
    let nextButtonActive = FillButton()
    let exception = Exception()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configure() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(backButtonClicked))
        self.navigationController?.navigationBar.tintColor = .black
        
        textLabel.text = "생년월일을 알려주세요"
        textLabel.font = UIFont().Display1_R20
        textLabel.textColor = .black
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        
        dateStackView.axis = .horizontal
        dateStackView.alignment = .center
        dateStackView.distribution = .fillEqually
        dateStackView.spacing = 23
        
        [yearStackView, monthStackView, dayStackView].forEach {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 4
        }
        
        yearTextField.placeholder = "1990"
        monthTextField.placeholder = "1"
        dayTextField.placeholder = "1"
        [yearTextField, monthTextField, dayTextField].forEach {
            $0.setDatePicker(target: self, selector: #selector(datePickerSaveClicked))
        }
        
        yearLabel.text = "년"
        yearLabel.font = UIFont().Title2_R16
        yearLabel.textColor = .black
        monthLabel.text = "월"
        monthLabel.font = UIFont().Title2_R16
        monthLabel.textColor = .black
        dayLabel.text = "일"
        dayLabel.font = UIFont().Title2_R16
        dayLabel.textColor = .black
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        nextButtonActive.setTitle("다음", for: .normal)
        nextButtonActive.addTarget(self, action: #selector(nextButtonActiveClicked), for: .touchUpInside)
        
        nextButtonActive.isHidden = true
    }
    
    override func setupConstraints() {
        view.addSubview(textLabel)
        view.addSubview(dateStackView)
        view.addSubview(nextButton)
        view.addSubview(nextButtonActive)
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(125)
            make.centerX.equalToSuperview()
        }
        
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        dateStackView.addArrangedSubview(yearStackView)
        yearStackView.addArrangedSubview(yearTextField)
        yearStackView.addArrangedSubview(yearLabel)
        yearLabel.snp.makeConstraints { make in
            make.width.equalTo(15)
        }
        
        dateStackView.addArrangedSubview(monthStackView)
        monthStackView.addArrangedSubview(monthTextField)
        monthStackView.addArrangedSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.width.equalTo(15)
        }
        
        dateStackView.addArrangedSubview(dayStackView)
        dayStackView.addArrangedSubview(dayTextField)
        dayStackView.addArrangedSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.width.equalTo(15)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(dateStackView.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        nextButtonActive.snp.makeConstraints { make in
            make.top.equalTo(dateStackView.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
    }
    @objc func datePickerSaveClicked(){
        let birth = DateFormatter().connectDateFormatString(date: UserData.birth).split(separator: "-").map{String($0)}
        
        yearTextField.text = birth[0]
        monthTextField.text = birth[1]
        dayTextField.text = birth[2]
        
        ageValid()
    }
    
    @objc func nextButtonClicked(){
        windows.last?.makeToast("새싹친구는 만 17세 이상만 사용할 수 있습니다.", duration: 3.0, position: .top)
    }
    
    @objc func nextButtonActiveClicked(){
        let vc = EmailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func ageValid(){
        let distanceDay = Calendar.current.dateComponents([.day], from: Date(), to: UserData.birth).day
        
        //만 17세 이상
        if -distanceDay! >= 6209{
            nextButton.isHidden = true
            nextButtonActive.isHidden = false
        } else{
            nextButton.isHidden = false
            nextButtonActive.isHidden = true
        }
    }
}

