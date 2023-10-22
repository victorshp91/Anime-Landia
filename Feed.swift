//
//  Feed.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/21/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct Feed: View {
    @State var ratings: RatingResponse?
    @State var currentPage = 1
    @State private var spoiler = false
    @State private var showSpoiler = false
    @State var accountData = [Usuario]()
    @State var showAccount = false
    @State var showUser = false
    @State var userData = AccountVm.sharedUserVM
    var body: some View {
        VStack {
            ZStack(alignment: .bottom){
                if let rating = ratings?.ratings {
                    VStack{
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            ForEach(rating, id: \.id) { rating in
                                RatingsView(rating: rating, showSpoiler: $showSpoiler)
                                    .padding()
                                
                                    .frame(maxWidth: .infinity)
                                    .background(Color("barColor"))
                                    .cornerRadius(10)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical)
                                
                            }
                        }
                    }.padding(.bottom,80)
                } else {
                    CustomLoadingView()
                }
                
                if showUser {
                    HStack{
                        
                        Button(action: {
                            showAccount = true
                            
                        }) {
                            UserProfilePictureView(userIdToFetch: userData.userActual.first?.id ?? "0", width: 60, height: 60)
                        }
               
                        .sheet(isPresented: $showAccount) {
                            NavigationStack {
                                AccountView()
                                    .presentationDetents([.medium, .large])
                                  
                                
                            }
                        }
                        Spacer()
                        Text(showSpoiler ? "Spoilers ON":"Spoilers OFF")
                        Toggle("", isOn: $showSpoiler)
                            .tint(.yellow).labelsHidden()
                    }
                    .padding(7)
                    .frame(maxWidth: .infinity)
                    .background(Color("accountNavColor"))
                    .cornerRadius(10)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical)
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background"))
        
            .onAppear(perform: {
                                
                loadRatings()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                        showUser = true
                   
                }
            })

        
       
    }
    
    func loadRatings() {
           // Load initial data with the current page value
           AnimeVM().fetchRatingsFeed(isAverage: false, page: "\(currentPage)") { fetchedRatings in
               self.ratings = fetchedRatings
           }
       }
}

struct RatingsView: View {
    let rating: Rating
    @Binding var showSpoiler: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if rating.spoiler == true && showSpoiler == false {
                SpoilerAlertView()
            } else {
                HStack {
                    UserProfilePictureView(userIdToFetch: rating.user_id ?? "0", width: 50, height: 50)
                    VStack(alignment: .leading){
                        Text("@\(rating.usuario ?? "N/A")")
                            .font(.headline)
                        if let createdAt = rating.created_at {
                            Text(" \(HelpersFunctions().formatDate(createdAt))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                   
                        AnimeImage(animeId: rating.anime_id ?? "")
                    
                    
                }
                HStack(alignment: .top){
                    
                    VStack(alignment:.leading){
                        if let ratingValue = rating.rating {
                            ratingView(animeRating: Double(ratingValue) ?? 0.0, anime: Anime(), isForUsersReview: true)
                        }
                        Text("\(rating.comment ?? "N/A")")
                            .font(.body)
                            .foregroundColor(.gray)
                        
                    }
                    if rating.spoiler == true {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                
            
            }
        }
    }
    
    
}

struct SpoilerAlertView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)
            Text("Spoiler Alert")
                .bold()
                .foregroundStyle(.yellow)
                .font(.title2)
        }
    }
}

struct AnimeImage: View {
    let animeId: String
    @State private var anime: Anime?

    
    var body: some View {
        VStack{
            if let animes = anime {
                NavigationLink(destination: AnimeDetailsView(anime: animes)){
                    WebImage(url: URL(string: animes.images?.jpg.image_url ?? ""))
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 60, height: 90)
                        .scaledToFill()
                        .shadow(radius: 5)
                        
                }
            }
        }.onAppear {
            // Cargar la imagen del anime aquí
            performFetch(animeId: animeId)
        }
    }

    func performFetch(animeId: String) {
        if let url = URL(string: "https://api.jikan.moe/v4/anime/\(animeId)") {
            AnimeVM.sharedAnimeVM.fetchData(from: url, resultType: OnlyAnimeData.self) { result in
                switch result {
                case .success(let decodedData):
                   
                    anime = decodedData.data
                case .failure(let error):
                    print("Error al cargar los datos: \(error)")
                }
            }
        }
    }
}

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        Feed()
    }
}
