//
//  HomeView.swift
//  City Sights App
//
//  Created by Michael Dobin on 2/8/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var isMapShowing = false
    @State var selectedBusiness: Business?
    var body: some View {
        
        if model.restaurants.count != 0 || model.sights.count != 0 {
            NavigationView {
                // determine if list or map
                if !isMapShowing {
                    //show list
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "location")
                            Text("San Fransisco")
                            Spacer()
                            Button("Switch to Map View") {
                                self.isMapShowing = true
                            }
                        }
                        Divider()
                        BusinessList()
                    }
                    .padding([.horizontal,.top])
                    .navigationBarHidden(true )
                }
                else {
                    //show map
                    BusinessMap(selectedBusiness: $selectedBusiness)
                        .ignoresSafeArea()
                        .sheet(item: $selectedBusiness) { business in
                            //create business detail view instance
                            BusinessDetail(business: business)
                        }
                }
            }
            
          
            
        }
        else {
           //still loading
            ProgressView()
        }
        
        
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
