//
//  AnimeDetailsView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI
import SDWebImageSwiftUI
struct AnimeDetailsView: View {
    @State var showTrailer = false
    @State var showAnimeImage = false
    let anime: Anime
    
    @State private var isShowingFullSypnosis = false
    
    // contiene los numeros de los conteos watchingStatus
    
    
    // PARA MANEJAR EL COLOR DEL DARK MODE
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            HStack{
                
                VStack(spacing: 10){
                    HStack(alignment: .top){
                        ZStack(alignment: .topTrailing) {
                            if showAnimeImage {
                                WebImage(url: URL(string: anime.images?.jpg.image_url ?? "N/A"))
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                    .frame(maxWidth: 200, maxHeight: 280)
                                    .shadow(radius: 3)
                                    .scaledToFill()
                                
                                AnimeWatchingButton(animeId: anime.mal_id ?? 0, changeOptionImageSize: 20)
                                
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 10){
                            
                           
                            VStack(alignment: .trailing,spacing: 0){
                                Text("Rank")
                                Text("#\(String(anime.rank ?? 0))").bold()
                            }
                            
                            VStack(alignment: .trailing,spacing: 0){
                                Text("Popularity")
                                Text("#\(String(anime.popularity ?? 0))").bold()
                            }
                            VStack(alignment: .trailing,spacing: 0){
                                Text("Episodes")
                                Text("\(String(anime.episodes ?? 0))").bold()
                            }
                            VStack(alignment: .trailing,spacing: 0){
                                Text("Ep. Lenght")
                                Text("\(anime.duration ?? "N/A")").bold()
                            }
                            
                            Text("\(anime.type ?? "N/A")").bold()
                                .padding(5)
                                .background(.red)
                            
                        }
                        
                    }.padding()
                        .foregroundStyle(.white)
                        .background(.cyan)
                        
                        
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .shadow(radius: 5)
                    // RATING VIEW
                    ratingView(anime: anime)
                    // COMIENZA EL TITLO DE EL ANIME
                    VStack(spacing: 10){
                        
                        
                        // Status Numbers
                        WatchingStatusNumbers(idAnime: anime.mal_id ?? 0)
                        
                        
                        Text("\(anime.title ?? "N/A")")
                            .font(.title3).bold()
                            .multilineTextAlignment(.center)
                       
                        
                        // AIRING SECTION
                        
                        if let airing = anime.airing {
                            Text("\(anime.status ?? "N/A")").foregroundStyle(airing ?  .green:.red).bold()
                        }
                        
                        // SI NO TIENE FECHA DE FINALIZACION ENTONCES PRESENTO LAS FECHAS DE INICIO Y FINAL
                        
                        if anime.aired?.to != nil {
                            Text(anime.aired?.string ?? "N/A")
                        }
                        
                        
                        Text(isShowingFullSypnosis ? anime.synopsis ?? "N/A" : HelpersFunctions().truncateText(text: anime.synopsis ?? "N/A"))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Button(action: {
                            withAnimation {
                                isShowingFullSypnosis.toggle()
                            }
                        }) {
                           
                               
                                Image(systemName: isShowingFullSypnosis ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundStyle(.white)
                                .font(.system(size: 22))
                                
                        }
                        
                        
                        // TRAILER SECTION
                        
                        sectionTitle(title: "Trailer")
                        if let youtubeUrl = anime.trailer?.url {
                            Button(action: {
                                showTrailer = true
                            }){
                                ZStack(alignment:.center){
                                    WebImage(url: URL(string: anime.trailer?.images.large_image_url ?? "N/A"))
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                        .scaledToFit()
                                    Image(systemName: "play.circle.fill")
                                        .foregroundStyle(.cyan)
                                        .font(.system(size: 75))
                                        .sheet(isPresented: $showTrailer) {
                                            
                                            TrailerVideoView(youtubeUrl: youtubeUrl )
                                                .presentationDetents([.medium, .large])
                                        }
                                }
                            }
                        } else {
                            Text("NO AVAILABLE")
                        }
                        // STRAMING SECTION
                        
                        sectionTitle(title: "Streaming")
                        StreamingDetailsView(animeId: anime.mal_id ?? 0)
                        
                    }.foregroundStyle(.white)
                    Spacer()
                }
                
            }.padding(.horizontal,5)
                .padding(.top)
           
        }
            .background(Color("background"))
            .navigationTitle("Details")
            .onAppear(perform: {
                print(anime.mal_id ?? "")
                withAnimation(.bouncy) {
                    showAnimeImage = true
                }
            })
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                        HStack{
                            FavoriteButtonView(favoriteFor: .anime, idCharacterOrAnime: anime.mal_id ?? 0)
                            ShareLink(item: (URL(string: anime.url ?? "N/A")!)) {
                                Image(systemName: "square.and.arrow.up.circle.fill")
        
                                    .font(.title2)
                                    
                                    
                            }
                            
                        }.foregroundStyle(.cyan)
                        
                    
                }
            }.toolbarBackground(
                Color("barColor"),
                for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        
    }
    
    func sectionTitle(title: String) -> some View {
        HStack{
            Spacer()
            Text(title).font(.title3).bold()
                .foregroundStyle(.white)
            Spacer()
        }.padding(5)
            .background(Color("barColor"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
   
    // PARA HACER LA SYPNOSIS MAS CORGA
    
   
}

struct WatchingStatusNumbers:  View {
    var idAnime: Int
    @State private var watchingNumbers: [AnimeWatchingStatusTotals] = []
    var body: some View {
        
            HStack{
                if let numbers = watchingNumbers.first {
                    
                    VStack{
                
                            
                        
                           
                                Image(systemName: "heart.circle.fill")
                                    
                                    .font(.title2)
                                   
                                    .foregroundColor(.cyan)
                                
                         
                                
                            
                        
                        Text("\(numbers.favorites)")
                        
                    }
                VStack{
                    Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: .watching, changeOptionImageSize: 20).icoImage)
                        .font(.title2)
                        .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: .watching, changeOptionImageSize: 20).iconColor)
                    Text("\(numbers.watching)")
                    
                }
                VStack{
                    Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: .hold, changeOptionImageSize: 20).icoImage)
                        .font(.title2)
                        .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: .hold, changeOptionImageSize: 20).iconColor)
                    Text("\(numbers.on_hold)")
                }
                VStack{
                    Image(systemName: AnimeWatchingButton(animeId: 0, selectedOption: .completed, changeOptionImageSize: 20).icoImage)
                        .font(.title2)
                        .foregroundStyle(AnimeWatchingButton(animeId: 0, selectedOption: .completed, changeOptionImageSize: 20).iconColor)
                    Text("\(numbers.completed)")
                }
            }
            }.onAppear(perform: {
                
                    getWathingStatusNumbers()
                
            })
            .font(.title2)
            .foregroundStyle(.white)
           
        
    }
    
    func getWathingStatusNumbers() {
        guard let url = URL(string: "\(DataBaseViewModel.sharedDataBaseVM.Dominio)\(DataBaseViewModel.sharedDataBaseVM.getAnimeWatchingStatusNumbers)id_anime=\(idAnime)") else {
                print("Invalid URL")
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode([AnimeWatchingStatusTotals].self, from: data)
                        DispatchQueue.main.async {
                            self.watchingNumbers = decodedData
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else if let error = error {
                    print("Error fetching data: \(error)")
                }
            }.resume()
        }
}
    
    



#Preview {
    AnimeDetailsView(anime: Anime(mal_id: 21))
}
