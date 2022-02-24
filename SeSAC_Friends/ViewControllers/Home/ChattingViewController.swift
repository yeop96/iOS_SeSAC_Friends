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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override func setupConstraints() {
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
    
    @objc func moreButtonClicked(){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
    }
    @objc func remainTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
    }
    @objc func reportTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
    }
    @objc func dodgeTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
        let popUpViewController = PopUpViewController(titleText: "약속을 취소하겠습니까?", messageText: "약속을 취소하시면 패널티가 부과됩니다")
        popUpViewController.confirmAction = {
            print("")
        }
        present(popUpViewController, animated: false, completion: nil)
    }
    @objc func rateTap(sender: UITapGestureRecognizer){
        moreView.isHidden.toggle()
        remainView.isHidden.toggle()
    }
    
}
