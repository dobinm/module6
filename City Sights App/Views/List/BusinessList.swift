//
//  BusinessList.swift
//  City Sights App
//
//  Created by Michael Dobin on 2/8/22.
//

import SwiftUI

struct BusinessList: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                BusinessSection(title: "Restaurants", businesses: model.restaurants)
                
                BusinessSection(title: "Sights", businesses: model.sights)
                
            }
            
            
            
        }
    }
    
    
    struct BusinessList_Previews: PreviewProvider {
        static var previews: some View {
            BusinessList()
        }
    }
}
