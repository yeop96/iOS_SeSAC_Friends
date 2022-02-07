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
        
        dismiss(animated: false, completion: nil)
    }

}


