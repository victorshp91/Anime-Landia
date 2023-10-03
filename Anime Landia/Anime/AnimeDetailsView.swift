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
    let anime: Anime
    @State private var isShowingFullSypnosis = false
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            HStack{
                Spacer()
                VStack(spacing: 10){
                    HStack(alignment: .top){
                        WebImage(url: URL(string: anime.images?.jpg.image_url ?? "N/A"))
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            .frame(maxWidth: 200, maxHeight: 280)
                            .shadow(radius: 3)
                            .scaledToFill()
                        Spacer()
                        VStack(alignment: .trailing, spacing: 10){
                            VStack(alignment: .trailing,spacing: 0){
                               
                                    
                                    Text("Score")
                                HStack{
                                    Image(systemName: "star.fill")
                                    Text(String(format: "%.2f", anime.score ?? 0)).bold()
                                }
                                
                                
                            }
                            VStack(alignment: .trailing,spacing: 0){
                                Text("Rank")
                                Text("#\(String(anime.rank ?? 0))").bold()
                            }
                            
                            VStack(alignment: .trailing,spacing: 0){
                                Text("Popularity")
                                Text("#\(String(anime.popularity ?? 0))").bold()
                            }
                            
                        }
                    }.padding()
                        
                        .background(.white)
                    
                        
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
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
                    
                    
                    Text(isShowingFullSypnosis ? anime.synopsis ?? "N/A" : truncateText(text: anime.synopsis ?? "N/A"))
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
                    
                    Spacer()
                }
                
            }
           Spacer()
        }.padding(.horizontal)
            .background(.ultraThickMaterial)
            .navigationTitle("Details")
            .onAppear(perform: {
                print(anime.mal_id ?? "")
            })
            .toolbar(.hidden, for: .tabBar)
        
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
    
    func truncateText(text: String, maxWords: Int = 25) -> String {
            let words = text.split(separator: " ")
            let truncatedText = words.prefix(maxWords).joined(separator: " ")
            return truncatedText + (words.count > maxWords ? "" : "")
        }
}

#Preview {
    AnimeDetailsView(anime: Anime(mal_id: 21))
}
