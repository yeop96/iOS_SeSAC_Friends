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
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}
