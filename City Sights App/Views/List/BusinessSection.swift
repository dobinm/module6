//
//  BusinessSection.swift
//  City Sights App
//
//  Created by Michael Dobin on 2/9/22.
//

import SwiftUI

struct BusinessSection: View {
    var title:String
    var businesses: [Business]
    
    var body: some View {
        Section (header: BusinessSectionHeader(title: title)) {
            ForEach(businesses) { business in
                
                NavigationLink(destination: BusinessDetail(business: business), label: {
                    BusinessRow(business: business)
                })
                
    }
}
    }
}
