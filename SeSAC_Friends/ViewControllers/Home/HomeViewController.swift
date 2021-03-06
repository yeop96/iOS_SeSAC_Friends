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

final class HomeViewController: BaseViewController {
    let mapView = MKMapView()
    let progress = JGProgressHUD()
    var locationManager = CLLocationManager()
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    let pin = MKPointAnnotation()
    let filterButton = FilterButton()
    let gpsButton = GPSButton()
    var floatingButton = FloatingButton(status: MatchingStatus.search.rawValue)
    let centerLocationView = UIImageView()
    var searchedFriends: SearchedFriends?
    var pickLocation: PickLocation?
    var currentLocation: CLLocation!
    var maleAnnotations = [CustomAnnotation]()
    var femaleAnnotations = [CustomAnnotation]()
    var selectFilter = GenderNumber.unSelect.rawValue
    var lat = 0.0
    var long = 0.0
    var region = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("아이디토큰", UserData.idToken)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideNavigationBar()
        tabBarController?.tabBar.isHidden = false
        floatingButton.setup(status: UserData.matchingStatus)
        searchFreinds()
    }
    
    override func configure() {
        centerLocationView.image = UIImage(named: "map_marker")
        
        filterButton.allButton.addTarget(self, action: #selector(filterAllButtonClicked), for: .touchUpInside)
        filterButton.allButtonClicked(sender: filterButton.allButton)
        filterButton.maleButton.addTarget(self, action: #selector(filterMaleButtonClicked), for: .touchUpInside)
        filterButton.femaleButton.addTarget(self, action: #selector(filterFemaleButtonClicked), for: .touchUpInside)
        
        floatingButton.addTarget(self, action: #selector(floatingButtonClicked), for: .touchUpInside)
        
        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: defaultCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        currentLocation = locationManager.location
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        
        
        gpsButton.addTarget(self, action: #selector(findMyLocation), for: .touchUpInside)
    }
    
    override func setupConstraints() {
        view.addSubview(mapView)
        view.addSubview(filterButton)
        view.addSubview(gpsButton)
        view.addSubview(floatingButton)
        view.addSubview(centerLocationView)
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
        centerLocationView.snp.makeConstraints { make in
            make.centerX.equalTo(mapView)
            make.centerY.equalTo(mapView).offset(-24)
            make.size.equalTo(48)
        }
    }
    
    @objc func filterAllButtonClicked(){
        selectFilter = GenderNumber.unSelect.rawValue
        searchFreinds()
    }
    @objc func filterMaleButtonClicked(){
        selectFilter = GenderNumber.male.rawValue
        searchFreinds()
    }
    @objc func filterFemaleButtonClicked(){
        selectFilter = GenderNumber.female.rawValue
        searchFreinds()
    }
    
    @objc func floatingButtonClicked(){
        tabBarController?.tabBar.isHidden = true
        
        switch UserData.matchingStatus{
        case MatchingStatus.search.rawValue:
            let vc = HobbySearchingViewController()
            vc.searchedFriends = self.searchedFriends
            vc.lat = self.lat
            vc.long = self.long
            vc.region = self.region
            UserData.lat = self.lat
            UserData.long = self.long
            UserData.region = self.region
            self.navigationController?.pushViewController(vc, animated: true)
        case MatchingStatus.matching.rawValue:
            let vc = FindUsersTabViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case MatchingStatus.matched.rawValue:
            let vc = ChattingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    func genderFilteredPin(gender: Int){
        mapView.removeAnnotations(self.mapView.annotations)
        switch gender {
        case GenderNumber.male.rawValue:
            mapView.addAnnotations(maleAnnotations)
        case GenderNumber.female.rawValue:
            mapView.addAnnotations(femaleAnnotations)
        default:
            mapView.addAnnotations(maleAnnotations)
            mapView.addAnnotations(femaleAnnotations)
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
    
    
    //주변 찾기
    func searchFreinds(){
        progress.show(in: view, animated: true)
        ServerService.shared.postSearchFriedns(region: self.region, lat: self.lat, long: self.long) { statusCode, data in
            switch statusCode{
            case ServerStatusCode.OK.rawValue:
                DispatchQueue.main.async {
                    self.maleAnnotations = []
                    self.femaleAnnotations = []
                    
                    self.searchedFriends = try? JSONDecoder().decode(SearchedFriends.self, from: data!)
                    
                    for otherUserInfo in self.searchedFriends!.fromQueueDB {
                        
                        if otherUserInfo.gender == GenderNumber.male.rawValue {
                            self.maleAnnotations.append(CustomAnnotation(sesac_image: otherUserInfo.sesac, coordinate: CLLocationCoordinate2D(latitude: otherUserInfo.lat, longitude: otherUserInfo.long)))
                        } else {
                            self.femaleAnnotations.append(CustomAnnotation(sesac_image: otherUserInfo.sesac, coordinate: CLLocationCoordinate2D(latitude: otherUserInfo.lat, longitude: otherUserInfo.long)))
                        }
                    }
                    
                    for otherUserInfo in self.searchedFriends!.fromQueueDBRequested {
                        
                        if otherUserInfo.gender == GenderNumber.male.rawValue {
                            self.maleAnnotations.append(CustomAnnotation(sesac_image: otherUserInfo.sesac, coordinate: CLLocationCoordinate2D(latitude: otherUserInfo.lat, longitude: otherUserInfo.long)))
                        } else {
                            self.femaleAnnotations.append(CustomAnnotation(sesac_image: otherUserInfo.sesac, coordinate: CLLocationCoordinate2D(latitude: otherUserInfo.lat, longitude: otherUserInfo.long)))
                        }
                        
                    }
                    
                    self.genderFilteredPin(gender: self.selectFilter)
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


extension HomeViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
        }
        
        //        guard let location = locations.last else { return }
        //
        //        lat = location.coordinate.latitude
        //        long = location.coordinate.longitude
        //        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        //
        //        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        //
        //
        //        mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
            
        } else {
            annotationView?.annotation = annotation
        }
        
        let sesacImage: UIImage!
        let size = CGSize(width: 85, height: 85)
        UIGraphicsBeginImageContext(size)
        
        sesacImage = SesacImage(rawValue: annotation.sesac_image ?? 0)?.sesacUIImage()
        
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        lat = mapView.centerCoordinate.latitude
        long = mapView.centerCoordinate.longitude
        region = controlRegion(lat: lat, long: long)
        
        print(lat,long,region)
        searchFreinds()
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

class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
