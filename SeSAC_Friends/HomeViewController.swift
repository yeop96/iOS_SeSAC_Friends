//
//  HomeViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/21.
//

import UIKit
import SnapKit
import Toast
import MapKit

class HomeViewController: BaseViewController {
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hideNavigationBar()
    }
    
    override func configure() {
        navigationController?.changeNavigationBar(isClear: true)
    }
    
    override func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}
