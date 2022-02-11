//
//  LaunchView.swift
//  City Sights App
//
//  Created by Michael Dobin on 1/27/22.
//

import SwiftUI
import CoreLocation

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        //detect authoritzation of geolocation
        
        if model.authorizationState == .notDetermined {
            
            //if undetermined show onboarding
            
        }
        else if model.authorizationState == .authorizedAlways ||
                    model.authorizationState == .authorizedWhenInUse {
            
            // if approved show home view
            HomeView()
        }
        
        else {
            //if denied show denied
        }
        
        
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
