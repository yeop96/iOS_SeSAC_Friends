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
    let userCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976)
    let pin = MKPointAnnotation()
    let filterButton = FilterButton()
    let gpsButton = GPSButton()
    var floatingButton = FloatingButton(status: .search)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hideNavigationBar()
    }
    
    override func configure() {
        navigationController?.changeNavigationBar(isClear: true)
        
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: userCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        pin.coordinate = userCoordinate
        pin.title = "클릭시 제목"
        pin.subtitle = "설명"
        mapView.addAnnotation(pin)

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
        
        guard let currentLocation = locationManager.location else {
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
            //유저
            return nil
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
