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
    @State private var favoritos: [Favorito] = []
    let anime: Anime
    @State private var isShowingFullSypnosis = false
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
                                
                                AnimeWatchingButton(changeOptionImageSize: 20)
                                
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 10){
                            
                            VStack(alignment: .trailing,spacing: 0){
                               
                                    
                                    Text("Score")
                                HStack{
                                    Image(systemName: "star.fill")
                                    Text(String(format: "%.2f", anime.score ?? 0)).bold()
                                }.foregroundStyle(.yellow)
                                
                                
                            }
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
                    // COMIENZA EL TITLO DE EL ANIME
                    VStack(spacing: 5){
                        
                        Text("\(anime.title ?? "N/A")")
                            .font(.title3).bold()
                            .multilineTextAlignment(.center)
                        
                        // AIRING SECTION
                        
                        if anime.airing == true
                        {
                            Text("Airing").foregroundStyle(.green).bold()
                        } else {
                            Text("Not Yet Aired").foregroundStyle(.red).bold()
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
                                .font(.system(size: 22))
                                .foregroundStyle(.black)
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
                        
                    }.padding(.horizontal)
                    Spacer()
                }
                
            }.padding(.horizontal,5)
           
        }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Details")
            .onAppear(perform: {
                verificarFavorito()
                print(anime.mal_id ?? "")
                withAnimation(.bouncy) {
                    showAnimeImage = true
                }
            })
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                        HStack{
                            Image(systemName: !favoritos.isEmpty ? "heart.fill":"heart")
                                .font(.title2)
                                .symbolEffect(.bounce, options: .speed(1).repeat(3), value: !favoritos.isEmpty)
                            ShareLink(item: (URL(string: anime.url ?? "N/A")!)) {
                                Image(systemName: "square.and.arrow.up.circle.fill")
        
                                    .font(.title2)
                                    
                                    
                            }
                            
                        }.foregroundStyle(.cyan)
                        
                    
                }
            }
        
        
    }
    
    func verificarFavorito() {
        if let url = URL(string: "https://rayjewelry.us/api.php?id_usuario=\(1)&id_anime=\(anime.mal_id ?? 0)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let favoritosData = try JSONDecoder().decode([Favorito].self, from: data)
                        DispatchQueue.main.async {
                            self.favoritos = favoritosData
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    func sectionTitle(title: String) -> some View {
        HStack{
            Spacer()
            Text(title).font(.title3).bold()
            
            Spacer()
        }.padding(5)
        .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
    // PARA HACER LA SYPNOSIS MAS CORGA
    
   
}

#Preview {
    AnimeDetailsView(anime: Anime(mal_id: 21))
}
