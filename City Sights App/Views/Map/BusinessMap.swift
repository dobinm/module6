//
//  BusinessMap.swift
//  City Sights App
//
//  Created by Michael Dobin on 2/11/22.
//

import SwiftUI
import MapKit

struct BusinessMap: UIViewRepresentable {
    @EnvironmentObject var model: ContentModel
    var locations: [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        
        //create set of annotations from list of business
        for business in model.restaurants + model.sights {
            //if business has lat long create mkpointannotion
            if let lat = business.coordinates?.latitude, let long = business.coordinates?.longitude {
                
                //create new annotations
                let a = MKPointAnnotation()
                a.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                a.title = business.name ?? ""
                
                annotations.append(a)
            }
            
            
           
        }
        return annotations
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView  = MKMapView()
        
        //make sure show up
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        //remove all annotations
        uiView.removeAnnotations(uiView.annotations)
        
        //add ones based on business
        uiView.showAnnotations(self.locations, animated: true)
        
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        
        uiView.removeAnnotations(uiView.annotations)
        
    }
}
