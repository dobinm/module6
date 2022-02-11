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
    @Binding var selectedBusiness: Business?
    
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
        mapView.delegate = context.coordinator
        
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
    
    // MARK -- coordinator class
    func makeCoordinator() -> Coordinator {
        return Coordinator(map: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var map: BusinessMap
        
        init(map: BusinessMap){
            self.map = map
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            //if annotation is user dot
            if annotation is MKUserLocation {
                return nil
            }
            
            // check if there is reusable annotation view
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationViewsId)
            
            if annotationView == nil {
                //create a new one
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationViewsId)
                
                
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                
                //we got reusable one
                annotationView!.annotation = annotation
            }
            
            //return it
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            //user tapped on annotation view
            
            
            // get business object that is represented
            //loop through business in model and find match
            for business in map.model.restaurants + map.model.sights {
                if business.name ==  view.annotation?.title {
                    map.selectedBusiness = business
                    return
                }
            }
            
        }
        
    }
}
