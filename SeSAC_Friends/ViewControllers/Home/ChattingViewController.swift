//
//  ChattingViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/15.
//

import UIKit
import SnapKit
import Toast

final class ChattingViewController: BaseViewController {
    var matchingPartner = ""
    let moreView = MoreView()
    let remainView = UIView()
    
    let tableView = UITableView()
    
    let sendingView = UIView()
    let textView = UITextView()
    let sendButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        SocketIOManager.shared.establishConnection()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketIOManager.shared.closeConnection()
    }
    
    override func configure() {
        title = matchingPartner
        navigationController?.changeNavigationBar(isClear: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .plain, target: self, action: #selector(rootBackButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreButtonClicked))
        self.navigationController?.navigationBar.tintColor = .black
        
        moreView.isHidden = true
        remainView.isHidden = true
        remainView.backgroundColor = .black.withAlphaComponent(0.5)
        let remainTapGesture = UITapGestureRecognizer(target: self, action: #selector(remainTap(sender:)))
        remainView.addGestureRecognizer(remainTapGesture)
        
        let reportTapGesture = UITapGestureRecognizer(target: self, action: #selector(reportTap(sender:)))
        moreView.reportStackView.addGestureRecognizer(reportTapGesture)
        let dodgeTapGesture = UITapGestureRecognizer(target: self, action: #selector(dodgeTap(sender:)))
        moreView.dodgeStackView.addGestureRecognizer(dodgeTapGesture)
        let rateTapGesture = UITapGestureRecognizer(target: self, action: #selector(rateTap(sender:)))
        moreView.rateStackView.addGestureRecognizer(rateTapGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        sendingView.layer.cornerRadius = 8
        sendingView.backgroundColor = .gray1
        textView.tintColor = .black
        textView.backgroundColor = .gray1
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.text = "메세지를 입력하세요"
        textView.font = UIFont().Body3_R14
        textView.textColor = .gray7
        textView.delegate = self
        sendButton.setImage(UIImage(named: "sendInact"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
    }
    
    override func setupConstraints() {
        
        view.addSubview(tableView)
        view.addSubview(sendingView)
        sendingView.addSubview(textView)
        sendingView.addSubview(sendButton)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(sendingView.snp.top)
        }
        sendingView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(14)
            make.trailing.equalTo(sendButton.snp.leading).inset(10)
            make.height.equalTo(24)
        }
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(textView)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(20)
        }
        
        view.addSubview(moreView)
        view.addSubview(remainView)
        moreView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(72)
        }
        remainView.snp.makeConstraints { make in
            make.top.equalTo(moreView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    @objc func rootBackButtonClicked(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func sendButtonClicked(){
        
    }
    
    @objc func moreButtonClicked(){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
        self.view.endEditing(true)
    }
    
    @objc func remainTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
    }
    @objc func reportTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
        self.view.makeToast("신고오", duration: 1.0, position: .top)
    }
    @objc func dodgeTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
        let popUpViewController = PopUpViewController(titleText: "약속을 취소하겠습니까?", messageText: "약속을 취소하시면 패널티가 부과됩니다")
        popUpViewController.confirmAction = {
            self.view.makeToast("취소오", duration: 1.0, position: .top)
        }
        present(popUpViewController, animated: false, completion: nil)
    }
    @objc func rateTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
        self.view.makeToast("평가아", duration: 1.0, position: .top)
    }
    
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

extension ChattingViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray7 {
               textView.text = nil
               textView.textColor = .black
           }
       }
       
       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "메세지를 입력하세요"
               textView.textColor = .gray7
           }
       }
       
       func textViewDidChange(_ textView: UITextView) {
           if textView.textColor == .gray7 || textView.text.count == 0 {
               sendButton.setImage(UIImage(named: "sendInact"), for: .normal)
           } else {
               sendButton.setImage(UIImage(named: "sendAct"), for: .normal)
           }
           
           let contentHeight = textView.contentSize.height
           DispatchQueue.main.async {
               if contentHeight <= 24 {
                   self.textView.snp.updateConstraints {
                       $0.height.equalTo(24)
                   }
               } else if contentHeight <= 48 {
                   self.textView.snp.updateConstraints {
                       $0.height.equalTo(48)
                   }
               } else {
                   self.textView.snp.updateConstraints {
                       $0.height.equalTo(72)
                   }
               }
           }
       }
}


class MyBubbleCell: UITableViewCell{
    static let identifier = "MyBubbleCell"
}
