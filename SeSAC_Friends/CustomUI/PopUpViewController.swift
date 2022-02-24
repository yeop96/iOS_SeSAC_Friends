//
//  PopUpViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/06.
//

import UIKit

class PopUpViewController: UIViewController{
    private var titleText: String?
    private var messageText: String?
    private var contentView: UIView?
    var confirmAction : (() -> ()) = {}

    private lazy var containerView: UIView = {
        let view = SesacAlert()
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        view.titleLabel.text = titleText
        view.descriptionLabel.text = messageText
        
        view.cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
        return view
    }()
    
    convenience init(titleText: String? = nil,
                     messageText: String? = nil) {
        self.init()
        self.titleText = titleText
        self.messageText = messageText
        
        modalPresentationStyle = .overFullScreen
    }
    convenience init(contentView: UIView) {
        self.init()

        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        view.backgroundColor = .black.withAlphaComponent(0.5)
    
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    
    @objc func dismissView(){
        dismiss(animated: false, completion: nil)
    }
    @objc func confirmButtonClicked(){
        confirmAction()
        //dismiss(animated: false, completion: nil)
    }

}

    
class MoreViewController: UIViewController{
    private var contentView: UIView?
    var reportAction : (() -> ()) = {}
    var dodgeAction : (() -> ()) = {}
    var rateAction : (() -> ()) = {}

    private lazy var containerView: UIView = {
        let view = MoreView()
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        view.mainStackView.backgroundColor = .white
        let reportTapGesture = UITapGestureRecognizer(target: self, action: #selector(reportTap(sender:)))
        view.reportStackView.addGestureRecognizer(reportTapGesture)
        let dodgeTapGesture = UITapGestureRecognizer(target: self, action: #selector(dodgeTap(sender:)))
        view.dodgeStackView.addGestureRecognizer(dodgeTapGesture)
        let rateTapGesture = UITapGestureRecognizer(target: self, action: #selector(rateTap(sender:)))
        view.rateStackView.addGestureRecognizer(rateTapGesture)
        
        return view
    }()
    
    convenience init(contentView: UIView) {
        self.init()
        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    @objc func reportTap(sender: UITapGestureRecognizer){
        reportAction()
    }
    @objc func dodgeTap(sender: UITapGestureRecognizer){
        dodgeAction()
    }
    @objc func rateTap(sender: UITapGestureRecognizer){
        rateAction()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: nil)
    }

}
