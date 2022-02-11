//
//  BusinessRow.swift
//  City Sights App
//
//  Created by Michael Dobin on 2/9/22.
//

import SwiftUI

struct BusinessRow: View {
    
    @ObservedObject var business: Business
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                //image
                let uiImage = UIImage(data: business.imageData ?? Data())
                Image(uiImage: uiImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58, height: 58)
                    .cornerRadius(5)
                
                //name and istance
                VStack(alignment: .leading) {
                    Text(business.name ?? "0")
                        .bold()
                    Text(String(format: "%.1f km away", (business.distance ?? 0)/1000))
                        .font(.caption)
                    
                }
                Spacer()
                
                //star and numbers
                VStack(alignment: .leading){
                    Image("regular_\(business.rating ?? 0)")
                    Text("\(business.reviewCount ?? 0) Reviews")
                    
                }
            }
            
            Divider()
            
        }
        .foregroundColor(.black)
    }
}

