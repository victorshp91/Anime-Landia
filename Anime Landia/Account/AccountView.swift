//
//  AccountView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/3/23.
//

import SwiftUI

extension Image {
    func asUIImage() -> UIImage {
        let uiView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let hostingController = UIHostingController(rootView: self)
        uiView.addSubview(hostingController.view)

        let renderer = UIGraphicsImageRenderer(size: uiView.bounds.size)
        let uiImage = renderer.image { _ in
            uiView.drawHierarchy(in: uiView.bounds, afterScreenUpdates: true)
        }

        hostingController.view.removeFromSuperview()

        return uiImage
    }
}

struct AccountView: View {
    
    var userData = AccountVm.sharedUserVM
    
    @State private var showLogin = false
    @State private var isShowingLogoutView = false
    @State private var selectedImage: Image?
    @State private var isPictureSaved = false
       @State private var showImagePicker = false
   
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment:.center){
                if !AccountVm.sharedUserVM.userActual.isEmpty {
                    VStack(alignment: .center){
                        if selectedImage != nil && isPictureSaved == false {
                            VStack{
                                selectedImage?
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color("barColor"), lineWidth: 3)) //
                                Button("Save Picture") {
                                    uploadPicture()
                                }.foregroundStyle(.blue)
                            }
                            
                        } else {
                            UserProfilePictureView(userIdToFetch: userData.userActual.first?.id, width: 100, height: 100)
                            Button("Change Picture") {
                                self.showImagePicker = true
                            }.foregroundStyle(.blue)
                                .sheet(isPresented: $showImagePicker) {
                                    ImagePicker(selectedImage: $selectedImage)
                                }
                        }
                        Text("@\(userData.userActual.first?.usuario ?? "")")
                            .bold()
                    }.font(.title3)
                }
                Button(action: {
                    if AccountVm.sharedUserVM.userActual.isEmpty {
                        showLogin = true
                    } else {
                        isShowingLogoutView.toggle()
                        
                    }
                }) {
                    HelpersFunctions.BotonMenuAccount(icono: "arrowshape.turn.up.right.circle.fill", titulo: userData.userActual.isEmpty ? "Sign In":"Sign Out", color: userData.userActual.isEmpty ? .green:.red)
                }
                    .sheet(isPresented: $showLogin) {
                        NavigationStack {
                            SignInView(isLoginPresented: $showLogin)
                                .presentationDetents([.medium, .large])
                        }
                    }
                    .sheet(isPresented: $isShowingLogoutView) {
                                SignOutConfirmationView(isShowingLogoutView: $isShowingLogoutView)
                            .presentationDetents([.medium])
                            }

                
                
                
                VStack(alignment: .leading){
                    Text("Friends").bold().font(.title2)
                    NavigationLink(destination: FriendsView(friendStatus: AccountVm.friendStatus.accepted)){
                        HelpersFunctions.BotonMenuAccount(icono: "person.2.circle.fill", titulo: "Friends", color: .orange)
                    }
                    NavigationLink(destination: FriendsView(friendStatus: AccountVm.friendStatus.pending)){
                        HelpersFunctions.BotonMenuAccount(icono: "bell.badge.circle.fill", titulo: "Otaku Connections", color: .orange)
                    }
                   
                    Text("Favorites").bold().font(.title2)
                    NavigationLink(destination: userFavoritesView(isFor: .character)){
                        HelpersFunctions.BotonMenuAccount(icono: "star.circle.fill", titulo: "My Favorites Characters", color: .cyan)
                    }
                    NavigationLink(destination: userFavoritesView(isFor: .anime)) {
                        HelpersFunctions.BotonMenuAccount(icono: "star.fill", titulo: "My Favorites Animes", color: .cyan)
                    }
                    
                    Text("Anime").bold().font(.title2)
                    NavigationLink(destination: UserWatchingView(friend: .init(), isFor: .watching)) {
                        HelpersFunctions.BotonMenuAccount(icono: "eye.circle.fill", titulo: "Watching", color: .blue)
                    }
                    
                    NavigationLink(destination: UserWatchingView(friend: .init(), isFor: .completed)) {
                        HelpersFunctions.BotonMenuAccount(icono: "checkmark.circle.fill", titulo: "Completed", color: .green)
                        
                    }
                    NavigationLink(destination: UserWatchingView(friend: .init(), isFor: .hold)) {
                        HelpersFunctions.BotonMenuAccount(icono: "pause.circle.fill", titulo: "On Hold", color: .gray)
                        
                    }
                }.disabled(userData.userActual.isEmpty)
                    .opacity(
                        userData.userActual.isEmpty ? 0.3:1
                    )
                
                    
                
                Text("Share").bold().font(.title2)
                ShareLink(item: URL(string: "https://apps.apple.com/us/app/data-ball-z/id1672899053")!) {
                    HelpersFunctions.BotonMenuAccount(icono: "shareplay", titulo: "Share this app", color: .cyan)
                    
                }
                Text("About").bold().font(.title2)
                NavigationLink(destination: AboutView()){
                    HelpersFunctions.BotonMenuAccount(icono: "info.circle.fill", titulo: "About", color: .cyan)
                }
                Text("Disclaimer").bold().font(.title2)
                VStack(alignment:.leading, spacing: 10){
                    Text("AnimeTracker Pro provides information about animes and characters for informational and entertainment purposes. We are not affiliated with the copyright holders of the animes mentioned in this application.")
                                    
                                    Text("All information, images, and content related to animes are the property of their respective owners and are used here for informational purposes.")
                                    
                                    Text("If you are the copyright owner of any content used in this application and wish for it to be removed or modified, please contact us, and we will address your requests promptly.")
                                    
                                    Text("This app is not intended to infringe upon any copyright and is offered as a reference tool for anime enthusiasts.")
                                    
                                    Text("All trademarks and copyrights belong to their respective owners. This application does not intend to usurp any copyright or infringe upon the intellectual property rights of third parties.")
                                    
                                    Text("Thank you for using our app.")
                }.font(.footnote)
                    .foregroundStyle(.white)
                Spacer()
            }.padding(.top)
        }.padding(.horizontal)
            .foregroundStyle(.white)
          
            .background(Color("background"))
      
    }
    
    func uploadPicture() {
        if let selectedImage = selectedImage, let imageData = selectedImage.asUIImage().jpegData(compressionQuality: 0.8) {
            let userId = AccountVm.sharedUserVM.userActual.first?.id ?? "0"

            // Create the URL for the PHP server with 'user_id' as a query parameter
            let urlString = "https://rayjewelry.us/animeLandiaApi/save_profile_picture.php?user_id=\(userId)"
            guard let url = URL(string: urlString) else {
                return
            }

            // Create a POST request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            // Set the content type to binary data
            request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

            // Set the image data as the request body
            request.httpBody = imageData

            // Realize the POST request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        withAnimation {
                            isPictureSaved = true
                        }
                        print("Response: \(responseString)")
                    }
                }
            }.resume()
        }
    }



    
    
}

#Preview {
    AccountView()
}
