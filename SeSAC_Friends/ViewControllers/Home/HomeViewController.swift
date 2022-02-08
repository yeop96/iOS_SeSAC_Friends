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
import CoreLocation


class HomeViewController: BaseViewController {
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    let pin = MKPointAnnotation()
    let filterButton = FilterButton()
    let gpsButton = GPSButton()
    var floatingButton = FloatingButton(status: .search)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func configure() {
        navigationController?.changeNavigationBar(isClear: true)
        
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: defaultCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        pin.coordinate = defaultCoordinate
        pin.title = "기본 위치"
        pin.subtitle = "위치 권한 설정을 허용해주세요"
        mapView.addAnnotation(pin)

        
        gpsButton.addTarget(self, action: #selector(findMyLocation), for: .touchUpInside)
    }
    
    override func setupConstraints() {
        view.addSubview(mapView)
        view.addSubview(filterButton)
        view.addSubview(gpsButton)
        view.addSubview(floatingButton)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        filterButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        gpsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(filterButton.snp.bottom).offset(16)
        }
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    @objc func findMyLocation() {
        
        guard let _ = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }

    
}


extension HomeViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            let annotationView = MKAnnotationView()
            annotationView.annotation = annotation
            annotationView.image = UIImage(named: "map_marker")
            return annotationView
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
            annotationView?.canShowCallout = true
            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
            miniButton.tintColor = .blue
            annotationView?.rightCalloutAccessoryView = miniButton
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "map_marker")
        return annotationView
    }
    
}
