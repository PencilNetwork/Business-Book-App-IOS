//
//  AnotherMapViewController.swift
//  LoginProject
//
//  Created by Mac on 8/16/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
protocol MapDelegate{
    func createMap(lat:Double,long:Double)
}
class AnotherMapViewController: UIViewController,UISearchBarDelegate,LocateOnTheMap ,CLLocationManagerDelegate ,GMSMapViewDelegate{
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            self.googleMapsView.clear()
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            self.lat = lat
            self.long = lon
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 16)
            self.googleMapsView.camera = camera
            marker.snippet = "Address : \(title)"
            marker.title = "Address : \(title)"
            marker.map = self.googleMapsView
            self.googleMapsView.selectedMarker = marker
            
        }
    }
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var googleMapsView: GMSMapView!
//    @IBOutlet weak var googleMapContainer: UIView!
   // var googleMapsView:GMSMapView!
    var searchResultController:SearchResultsController!
    var resultsArray = [String]()
     var gmsFetcher: GMSAutocompleteFetcher!
    var lat:Double? = 0
    var long:Double? = 0
    var address:String? = ""
    var locationManager = CLLocationManager()
    var resultPlaceID = [String]()
    var mapDelegate:MapDelegate?
     let locationBtn = UIButton()
   
//    var searchCoordination:[coordination] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        googleMapsView.delegate = self
        confirmBtn.layer.cornerRadius = 10 
       self.navigationController?.isNavigationBarHidden = true
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
         
        }
        self.locationManager.delegate = self
        locationBtn.frame = CGRect(x:  20, y: (googleMapsView.frame.height/8) - 40, width: 46, height: 46)
        locationBtn.setImage(UIImage(named:"Currentlocationbtn.png"), for: .normal)
        locationBtn.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        self.googleMapsView.addSubview(locationBtn)
        // Do any additional setup after loading the view.
    }
    @objc func getCurrentLocation(){
        self.locationManager.startUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 16.0)
        
        googleMapsView.camera = camera
        googleMapsView.clear()
        
        print("currentlocation",lat!,long!)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        getAddressFromLatLon(pdblLatitude: lat!, withLongitude: long!,marker: marker)
        marker.map = googleMapsView
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
   self.navigationController?.isNavigationBarHidden = true
//        self.googleMapsView = GMSMapView(frame: self.googleMapContainer.frame)
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 16)
        self.googleMapsView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        marker.map = self.googleMapsView
        getAddressFromLatLon(pdblLatitude: lat!, withLongitude: long!,marker: marker)
        self.googleMapsView.selectedMarker = marker
        
//       self.view.addSubview(googleMapsView)
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        googleMapsView.clear()
        //hello
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        getAddressFromLatLon(pdblLatitude: coordinate.latitude, withLongitude: coordinate.longitude,marker: marker)
        lat = coordinate.latitude
        long = coordinate.longitude
        marker.map = googleMapsView
          self.googleMapsView.selectedMarker = marker
   
        
    }
//ActionFor search location by address
    
    @IBAction func searchBtnAction(_ sender: Any)  {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        let placeClient = GMSPlacesClient()
       
        let filter = GMSAutocompleteFilter()
        filter.country = "EG"
                placeClient.autocompleteQuery(searchText, bounds: nil, filter: filter)  {(results, error: Error?) -> Void in
                   // NSError myerr = Error;
                    print("Error @%",Error.self)

                    self.resultsArray.removeAll()
                    self.resultPlaceID.removeAll()
                    if results == nil {
                        return
                    }

                    for result in results! {
                        if let result = result as? GMSAutocompletePrediction {
                            print(result)
                            self.resultsArray.append(result.attributedFullText.string)
                           print("Primary\(result.attributedPrimaryText)")
                             self.resultPlaceID.append(result.placeID!)
                            
//                            placeClient.lookUpPlaceID(result.placeID!, callback: {(place:GMSPlace?,error:NSError?) ->Void in
//                                            if let place = place{
////                                                var coordinate = coordination(lat: place.coordinate.latitude,long: place.coordinate.longitude)
////                                                self.searchCoordination.append(coordinate)
//                                            }
//                                            } as! GMSPlaceResultCallback)
                            //self.resultPlaceID.append(result.placeID!)
                        }
                    }

                    self.searchResultController.reloadDataWithArray(self.resultsArray,searchPlaceID: self.resultPlaceID)

                }
    
//        placeClient.lookUpPlaceID("", callback: {(place:GMSPlace?,error:NSError?) ->Void in
//            if let place = place{
//            place.coordinate.longitude
//            }
//            } as! GMSPlaceResultCallback)
    }
    @IBAction func currentLocationBtn(_ sender: Any) {
        self.locationManager.startUpdatingLocation()
//        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 16.0)
//
//        googleMapsView.camera = camera
//        googleMapsView.clear()
//
//        print("currentlocation",lat!,long!)
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
//         getAddressFromLatLon(pdblLatitude: lat!, withLongitude: long!,marker: marker)
//        marker.map = googleMapsView
    }
    
    @IBAction func confirmAction(_ sender: Any) {
       
        mapDelegate?.createMap(lat: lat!, long: long!)
        self.navigationController?.popViewController(animated: false)
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double,marker: GMSMarker) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        //21.228124
        let lon: Double = pdblLongitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        var addressString : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }else { // success
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        self.address = addressString
                        print(addressString)
                        
                        marker.title =  addressString
                        marker.snippet = addressString
                    }
                }
        })
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = locValue.latitude
        long = locValue.longitude
        locationManager.stopUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 16.0)
        
        googleMapsView.camera = camera
        googleMapsView.clear()
        
        print("currentlocation",lat!,long!)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        getAddressFromLatLon(pdblLatitude: lat!, withLongitude: long!,marker: marker)
        marker.map = googleMapsView
         self.googleMapsView.selectedMarker = marker
     
    }
}
