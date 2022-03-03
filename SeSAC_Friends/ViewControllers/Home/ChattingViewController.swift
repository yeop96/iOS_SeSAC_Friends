//
//  ChattingViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/15.
//

import UIKit
import SnapKit
import Toast
import JGProgressHUD

final class ChattingViewController: BaseViewController {
    let progress = JGProgressHUD()
    let moreView = MoreView()
    let remainView = UIView()
    
    //let tableView = UITableView(frame: .zero, style: .plain)
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let sendingView = UIView()
    let textView = UITextView()
    let sendButton = UIButton()
    
    var myState: MyState?
    var chats: Chats?
    var matchingPartner = UserData.matchedNick
    var matchingUID = UserData.matchedUID
    var chatList = [Chat](){
        didSet{
            tableView.reloadData()
            if self.chatList.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(noti:)), name: NSNotification.Name("getMessage"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.changeNavigationBar(isClear: true)
        checkState()
        getChatting()
        SocketIOManager.shared.establishConnection()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(MyBubbleCell.self, forCellReuseIdentifier: MyBubbleCell.identifier)
        tableView.register(FriendBubbleCell.self, forCellReuseIdentifier: FriendBubbleCell.identifier)
        tableView.register(MatchingInformationCell.self, forHeaderFooterViewReuseIdentifier: MatchingInformationCell.identifier)
        
        //tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70))
        
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
        sendingMessage()
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
        self.view.makeToast("1_5_1_report_user", duration: 1.0, position: .top)
    }
    @objc func dodgeTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
        let popUpViewController = PopUpViewController(titleText: "약속을 취소하겠습니까?", messageText: "약속을 취소하시면 패널티가 부과됩니다")
        popUpViewController.confirmAction = {
            self.dodge()
        }
        present(popUpViewController, animated: false, completion: nil)
    }
    @objc func rateTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
        self.view.makeToast("1_5_3_write_review", duration: 1.0, position: .top)
    }
    
    //취소
    func dodge(){
        progress.show(in: view, animated: true)
        ServerService.shared.postDodge(uid: UserData.matchedUID) { statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                DispatchQueue.main.async {
                    UserData.matchingStatus = MatchingStatus.search.rawValue
                    self.dismiss(animated: false) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.dodge()
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
    
    //상태 확인
    @objc func checkState() {
        progress.show(in: view, animated: true)
        ServerService.shared.getMyState(){ statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                self.myState = try? JSONDecoder().decode(MyState.self, from: data!)
                if self.myState?.dodged == 1 || self.myState?.reviewed == 1{
                    self.view.makeToast("\(String(describing: self.myState?.matchedNick))님과 약속이 종료되어 채팅을 보낼 수 없습니다", duration: 1.0, position: .bottom)
                    UserData.matchingStatus = MatchingStatus.search.rawValue
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }else if self.myState?.matched == 1{
                    UserData.matchingStatus = MatchingStatus.matched.rawValue
                    UserData.matchedNick = self.myState!.matchedNick
                    UserData.matchedUID = self.myState!.matchedUid
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.checkState()
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
    
    //보내기
    func sendingMessage(){
        progress.show(in: view, animated: true)
        ServerService.shared.postSendingChatting(chat: self.textView.text) { statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                print("보내기")
                DispatchQueue.main.async {
                    self.textView.text = ""
                    self.view.endEditing(true)
                    self.sendButton.setImage(UIImage(named: "sendInact"), for: .normal)
                    self.getChatting()
                }
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.sendingMessage()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            default:
                print("보내기 ERROR: ", statusCode)
            }
        }
        self.progress.dismiss(animated: true)
    }
    
    //메시지 가져오기
    @objc func getChatting() {
        progress.show(in: view, animated: true)
        ServerService.shared.getChatting(lastchatDate: "2000-01-01T00:00:00.000Z") { statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                self.chats = try? JSONDecoder().decode(Chats.self, from: data!)
                self.chatList = self.chats!.payload
                
                if self.chatList.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1, section: 0), at: .bottom, animated: false)
                }
                
            case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                ServerService.updateIdToken { result in
                    switch result {
                    case .success:
                        self.getChatting()
                    case .failure(let error):
                        print(error.localizedDescription)
                        return
                    }
                }
            default:
                print("채팅 가져오기 ERROR: ", statusCode)
            }
        }
        self.progress.dismiss(animated: true)
    }
    
    @objc func getMessage(noti: NSNotification) {
        let id = noti.userInfo!["_id"] as! String
        let v = noti.userInfo!["__v"] as! Int
        let to = noti.userInfo!["to"] as! String
        let from = noti.userInfo!["from"] as! String
        let chat = noti.userInfo!["chat"] as! String
        let createdAt = noti.userInfo!["createdAt"] as! String
        
        let value = Chat(id: id, v: v, to: to, from: from, chat: chat, createdAt: createdAt)
        
        self.chatList += [value]
    }
    
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MatchingInformationCell.identifier) as! MatchingInformationCell
        header.matchingLabel.text = "\(matchingPartner)님과 매칭되었습니다"
        return header
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .white
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = chatList[indexPath.row]
        if row.from == UserData.myUID{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendBubbleCell.identifier, for: indexPath) as? FriendBubbleCell else {
                return UITableViewCell()
            }
            
            cell.messageLabel.text = row.chat
            cell.timeLabel.text = row.createdAt.toDate
            
            return cell
            
        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyBubbleCell.identifier, for: indexPath) as? MyBubbleCell else {
                return UITableViewCell()
            }
            
            cell.messageLabel.text = row.chat
            cell.timeLabel.text = row.createdAt.toDate
            
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !tableView.isDecelerating {
            view.endEditing(true)
        }
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

final class MatchingInformationCell: UITableViewHeaderFooterView{
    static let identifier = "MatchingInformationCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    let bellImageView = UIImageView()
    let matchingLabel = UILabel()
    let noticeLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setupConstraints()
    }
    
    func configure(){
        bellImageView.image = UIImage(named: "bell")
        bellImageView.tintColor = .gray7
        
        matchingLabel.text = "친구님과 매칭되었습니다"
        matchingLabel.font = UIFont().Title3_M14
        matchingLabel.textColor = .gray7
        
        noticeLabel.text = "채팅을 통해 약속을 정해보세요 :)"
        noticeLabel.font = UIFont().Title4_R14
        noticeLabel.textColor = .gray6
    }
    
    func setupConstraints(){
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(bellImageView)
        stackView.addArrangedSubview(matchingLabel)
        contentView.addSubview(noticeLabel)
//        contentView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.height.equalTo(70)
//        }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        bellImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



final class MyBubbleCell: UITableViewCell{
    static let identifier = "MyBubbleCell"
    let bubbleView = UIView()
    
    let messageLabel = UILabel()
    
    let timeLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setupConstraints()
    }
    
    func configure(){
        self.selectionStyle = .none
        bubbleView.layer.cornerRadius = 8
        bubbleView.layer.borderWidth = 1
        bubbleView.layer.borderColor = UIColor.gray4.cgColor
        bubbleView.clipsToBounds = true
        bubbleView.backgroundColor = .clear
        
        messageLabel.textColor = .black
        messageLabel.font = UIFont().Body3_R14
        messageLabel.numberOfLines = 0
        
        timeLabel.textColor = .gray6
        timeLabel.font = UIFont().Title6_R12
    }
    
    func setupConstraints(){
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        bubbleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(timeLabel.snp.leading).offset(-8)
            make.width.lessThanOrEqualTo(264)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bubbleView.snp.bottom)
            make.leading.equalTo(bubbleView.snp.trailing).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class FriendBubbleCell: UITableViewCell{
    static let identifier = "FriendBubbleCell"
    
    let bubbleView = UIView()
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setupConstraints()
    }
    
    func configure(){
        self.selectionStyle = .none
        
        bubbleView.layer.cornerRadius = 8
        bubbleView.clipsToBounds = true
        bubbleView.backgroundColor = .whiteGreen
        
        messageLabel.textColor = .black
        messageLabel.font = UIFont().Body3_R14
        messageLabel.numberOfLines = 0
        
        timeLabel.textColor = .gray6
        timeLabel.font = UIFont().Title6_R12
    }
    
    func setupConstraints(){
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        bubbleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(timeLabel.snp.trailing).offset(8)
            make.width.lessThanOrEqualTo(264)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bubbleView.snp.bottom)
            make.trailing.equalTo(bubbleView.snp.leading).offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
