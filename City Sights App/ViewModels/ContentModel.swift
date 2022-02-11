//
//  ContentModel.swift
//  City Sights App
//
//  Created by Michael Dobin on 1/27/22.
//

import Foundation
import CoreLocation
class ContentModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager = CLLocationManager()
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    
    @Published var restaurants = [Business]()
    @Published var sights = [Business]()
    
    override init() {
        
        //init method of NSObject
        super.init()
        //set content model as delegate of location manger
        locationManager.delegate = self
        
        //request permission from user
        locationManager.requestWhenInUseAuthorization()
        
       
        
    }
    
    //MARK -  Location Manager Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //update authorization state
        
        authorizationState = locationManager.authorizationStatus
        
        if locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            
            //we have permission
            //start geolocating user after gettin permission
            locationManager.startUpdatingLocation()
        }
        else if locationManager.authorizationStatus == .denied {
            //we don't have permission
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //gives us location of user
        let userLocation = locations.first
        
        if userLocation != nil {
            //we have location
            //stop requesting loaction
            locationManager.stopUpdatingLocation()
            
            //if we have coordinates of user send into Yelp API
            getBusinesses(category: Constants.sightsKey, location: userLocation!)
            getBusinesses(category: Constants.restuarantsKey, location: userLocation!)
            
        }
       
        
        
    }
    
    //MARK: Yelp API methods
    
    func getBusinesses(category:String, location:CLLocation) {
        
        //create url
        /*let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&categories=\(category)&limit=6"
        let url = URL(string: urlString)
        */
        var urlComponents = URLComponents(string: Constants.apiUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]
        let url = urlComponents?.url
        if let url = url {
            //create url request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
            //get url session
            let session = URLSession.shared
    
            //create data task
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                //check there isn't an error
                if error == nil {
                   
                    do{
                        //parse json
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(BusinessSearch.self, from: data!)
                        
                        // sort businesses
                        var businesses = result.businesses
                        businesses.sort { (b1, b2) -> Bool in
                            return b1.distance ?? 0 < b2.distance ?? 0
                            
                        }
                        
                        //call the get image function of the business
                        for b in businesses {
                            b.getImageData()
                        }
                        
                        
                        DispatchQueue.main.async {
                            
                            //assign results to property
                            
                            switch category {
                            case Constants.sightsKey:
                                self.sights = businesses
                            case Constants.restuarantsKey:
                                self.restaurants = businesses
                            default:
                                break
                            }
                        }
                        
                        

 
                    }
                    
                    catch{
                        print(error)
                        
                    }
                   
                }
            }
            //start data task
            dataTask.resume()
        }
        
        
       
    }
    
}
