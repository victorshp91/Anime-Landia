//
//  UserProfilePictureView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/17/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfilePictureView: View {
    var userIdToFetch: String
    var width: CGFloat?
    var height: CGFloat?
    @State var url = ""
       var body: some View {
           
           WebImage(url: URL(string: url))
               .onFailure(perform: {_ in
                   url = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
               })
            
               .resizable()
               .scaledToFill()
               .frame(width: width, height: height)
               .clipShape(Circle())
               .overlay(Circle().stroke(Color("barColor"), lineWidth: 3)) // Optional: Add a border
               .onAppear(perform: {
                   
                  
                   url = "https://rayjewelry.us/animeLandiaApi/get_user_image.php?user_id=\(userIdToFetch)"
                   
                  
               })
              
         
            
               
           
       }
}

#Preview {
    UserProfilePictureView(userIdToFetch: "")
}
