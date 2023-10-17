//
//  ratingView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/14/23.
//

import SwiftUI

struct ratingView: View {
    @State var animeRating = 0.0
    let anime: Anime
    @State var showRatings = false
    @State var isForUsersReview = false
    

        var body: some View {
            HStack {
                ForEach(0..<5) { index in
                    
                        Image(systemName: index < Int(animeRating) ? "star.fill" : "star")
                            .foregroundColor(Color.cyan)
                            
                    
                }
                Text(String(format: "%.1f", animeRating)).bold()
                    .foregroundStyle(.white
                    )
                Spacer()
                if !isForUsersReview {
                    HStack {
                        Button(action: {
                            showRatings = true
                        }) {
                            Image(systemName: "ellipsis.message.fill")
                            
                        }
                        .padding(10)
                        .background(Color.cyan)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                    }
                }
                
            }.font(.title2)
            .padding(isForUsersReview ? 0:10)
                
            .background(Color("barColor"))    // Color de fondo en azul
            
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .sheet(isPresented: $showRatings) {
                    NavigationStack {
                        AnimeRatingDetailsView(anime: anime)
                            .presentationDetents([.medium, .large])
                            .onDisappear {
                                // Esta acción se ejecutará cuando el Sheet se oculte
                                if !isForUsersReview {
                                    AnimeVM.sharedAnimeVM.fetchRatingsForAnime(animeId: anime.mal_id ?? 0, isAverage: true, page: "1", completion: { rating in
                                        if let average = rating.average {
                                            animeRating = average
                                        }
                                    })
                                }
                            }
                    }
                }
                
                .onAppear(perform: {
                    if !isForUsersReview {
                        AnimeVM.sharedAnimeVM.fetchRatingsForAnime(animeId: anime.mal_id ?? 0, isAverage: true, page: "1", completion: { rating in
                            if let average = rating.average{
                                animeRating = average
                            }
                            
                            
                        })
                    }
                })
                
                
                
        }
}

#Preview {
    ratingView(anime: Anime.init(mal_id: 6033))
        .font(.largeTitle)
                    .padding()
}
