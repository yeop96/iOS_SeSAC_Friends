//
//  HomeViewController.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/21.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import JGProgressHUD


class HomeViewController: BaseViewController {
    let mapView = MKMapView()
    let progress = JGProgressHUD()
    var locationManager = CLLocationManager()
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    let pin = MKPointAnnotation()
    let filterButton = FilterButton()
    let gpsButton = GPSButton()
    var floatingButton = FloatingButton(status: .search)
    var searchedFriends: SearchedFriends?
    var pickLocation: PickLocation?
    var currentLocation: CLLocation!
    var maleAnnotations = [CustomAnnotation]()
    var femaleAnnotations = [CustomAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hideNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchFreinds()
    }
    
    override func configure() {
        navigationController?.changeNavigationBar(isClear: true)
        
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: defaultCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        currentLocation = locationManager.location
        
        
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
    
    
    //region 값 변환
    func controlRegion(lat: Double, long: Double) -> Int{
        var strLat = String(lat+90)
        var strLong = String(long+180)
        
        strLat = strLat.components(separatedBy: ["."]).joined()
        strLong = strLong.components(separatedBy: ["."]).joined()
        
        let strRegion = substring(str: strLat ,from: 0, to: 4) + substring(str: strLong, from: 0, to: 4)
        
        return Int(strRegion) ?? 0
    }
    func substring(str: String, from: Int, to: Int) -> String {
        guard from < str.count, to >= 0, to - from >= 0 else { return "" }
        
        let startIndex = str.index(str.startIndex, offsetBy: from)
        let endIndex = str.index(str.startIndex, offsetBy: to + 1)
        
        return String(str[startIndex ..< endIndex])
    }
    
    //성별
//    func genderFilteredPin(gender: Int){
//        mapView.removeAnnotations(self.mapView.annotations)
//
//        switch gender {
//        case GenderNumber.male.rawValue:
//            //mapView.addAnnotations(manAnnotations)
//        case GenderNumber.female.rawValue:
//            //mapView.addAnnotations(womanAnnotations)
//        default:
//            //mapView.addAnnotations(manAnnotations)
//            //mapView.addAnnotations(womanAnnotations)
//        }
//    }
    
    //주변 찾기
    func searchFreinds(){
        progress.show(in: view, animated: true)
        DispatchQueue.global().async {
            ServerService.shared.postSearchFriedns(region: 1275130688, lat: 37.517819364682694, long: 126.88647317074734) { statusCode, data in
                switch statusCode{
                case ServerStatusCode.OK.rawValue:
                    DispatchQueue.main.async {
                        self.searchedFriends = try? JSONDecoder().decode(SearchedFriends.self, from: data!)
                        print("누구인가", self.searchedFriends as Any)
                    }
                case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                    ServerService.updateIdToken { result in
                        switch result {
                        case .success:
                            self.searchFreinds()
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
        
        
    }

    
}


extension HomeViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
        }
    }
    
    
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


class CustomAnnotation: NSObject, MKAnnotation {
  let sesac_image: Int?
  let coordinate: CLLocationCoordinate2D

  init(
    sesac_image: Int?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.sesac_image = sesac_image
    self.coordinate = coordinate

    super.init()
  }

}
