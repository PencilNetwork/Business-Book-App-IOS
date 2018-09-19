//
//  SearchResultsController.swift
//  PlacesLookup
//
//  Created by Malek T. on 9/30/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import GoogleMaps
import GooglePlaces
protocol LocateOnTheMap{
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

class SearchResultsController: UITableViewController {
    
    var searchResults: [String]!
    var delegate: LocateOnTheMap!
    var latt:Double?
    var longt:Double?
    var searchPlaceID :[String] = []
//    var searchCoordination:[coordination]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResults.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        // 1
        self.dismiss(animated: true, completion: nil)
        let placeClient = GMSPlacesClient()
        placeClient.lookUpPlaceID(searchPlaceID[indexPath.row], callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for")
                return
            }
            
            self.delegate.locateWithLongitude(place.coordinate.longitude, andLatitude: place.coordinate.latitude, andTitle: self.searchResults[indexPath.row])
            print("Place name \(place.name)")
            
            print("Place address \(place.formattedAddress)")
            print("Place placeID \(place.placeID)")
            print("Place attributions \(place.attributions)")
        })
    
       


//        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResults[indexPath.row])&sensor=false&key=AIzaSyBBk2-xtxTDDxxEaFfw64nVsjm6QMBGu1Y".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//
//        let url = URL(string: urlpath!)
//        // print(url!)
//        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
//            // 3
//
//            do {
//                if data != nil{
//                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
//                    print(dic)
//                    if let error = dic["error_message"]{
//                        print("error in geocoder")
//                    }else{
//                       if let x = dic["results"] {
//                            let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
//
//                           let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
//                    // 4
//                        self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row])
//                    }else{ // error
//
//                    }
//
//                     }
//                }
//
//            }catch {
//                print("Error")
//            }
//        }
//        // 5
//        task.resume()
    }
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
      
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
       
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
               self.latt = coordinate.latitude
                self.longt = coordinate.longitude
                
            } else {
                print("No Matching Location Found")
            }
        }
    }
    
    func reloadDataWithArray(_ array:[String],searchPlaceID:[String]){
        //self.searchPlaceID = searchPlaceId
        self.searchPlaceID = searchPlaceID
        self.searchResults = array
        self.tableView.reloadData()
    }
    func getAddress(address:String){
        
        let key : String = "AIzaSyBZB59S_sVHjKG0g7o1MwSrfTwJgaYlERo"
        let postParameters:[String: Any] = [ "address": address,"key":key]
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        
        Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
            
            if let receivedResults = response.result.value
            {
                print("result",receivedResults)
//                let resultParams = JSON(receivedResults)
//                print(resultParams) // RESULT JSON
//                print(resultParams["status"]) // OK, ERROR
//                print(resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue) // approximately latitude
//                print(resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue) // approximately longitude
            }
        }
    }
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
  
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
