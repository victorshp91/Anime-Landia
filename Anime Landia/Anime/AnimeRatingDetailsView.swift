//
//  AnimeRatingDetailsView.swift
//  AnimeTracker Pro
//
//  Created by Victor Saint Hilaire on 10/14/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct AnimeRatingDetailsView: View {
    let anime: Anime
    @State var ratings: RatingResponse?
    @State var currentPage = 1
    @State var sendReview = false
    @State private var rating = 5
    @State private var comment = ""
    @State private var spoiler = false // Inicialmente, no es spoiler cuando envia un review
    @State private var showSpoiler = false // Para mostrar o no todos los spoilers
    
    var body: some View {
        VStack(spacing: 0) {
            
            if !sendReview {
                headerView()
                
            }
            
                // FORMULARIO PARA ENVIAR REVIEW
                ZStack(alignment:.center) {
                
                   
                        
                ScrollView(.vertical, showsIndicators: false) {
                    
                    if !AccountVm.sharedUserVM.userActual.isEmpty {
                        
                        Button(action: {
                            withAnimation {
                                sendReview = true
                            }
                        }){
                            
                            HStack{
                                Text("Leave your review")
                                Image(systemName: "text.bubble.fill")
                                    .font(.largeTitle).bold()
                                    .foregroundStyle(.cyan)
                            }.padding()
                                .foregroundStyle(.white)
                            
                                .frame(maxWidth: .infinity)
                                .background(Color("barColor"))    // Color de fondo en azul
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding()
                        }
                        
                    }
            
                    if let rating = ratings?.ratings {
                        
                        HStack{
                            Spacer()
                            Text("Show Spoilers").bold()
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                            Toggle("", isOn: $showSpoiler)
                                .tint(.yellow)
                        }
                        .padding()
                                .foregroundStyle(.white)
                                .background(Color("barColor"))    // Color de fondo en azul
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding()
                        
                        ForEach(rating, id: \.id) { rating in
                            VStack(alignment: .leading, spacing: 10) {
                                if rating.spoiler == true  && showSpoiler == false{
                                    VStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundStyle(.yellow)
                                        Text("Spoiler Alert").bold().foregroundStyle(.yellow)
                                            .font(.title2)
                                    }
                                    
                                } else {
                                    HStack{
                                        
                                        UserProfilePictureView(userIdToFetch: rating.user_id, width: 50, height: 50)
                                        Text("@\(rating.usuario ?? "N/A")")
                                            .font(.headline)
                                        Spacer()
                                        if let createdAt = rating.created_at {
                                            Text(" \(formatDate(createdAt))")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    HStack {
                                        
                                        if let ratingValue = rating.rating {
                                            ratingView(animeRating: Double(ratingValue) ?? 0.0, anime: Anime(), isForUsersReview: true)
                                        }
                                        Spacer()
                                        if rating.spoiler == true {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .foregroundStyle(.yellow)
                                        }
                                        
                                    }
                                    
                                    Text("\(rating.comment ?? "N/A")")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("barColor"))
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.top)
                            
                        }
                    }
                }.opacity(sendReview == true ? 0:1)
                    
                    
                    if sendReview {
                        
                        formSendRiview()
                        
                    }
            }
            
            Spacer()
        } .background(Color("background"))
        

        .onAppear {
            loadData()
        }
    }
    
    func formSendRiview() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Spacer()
                VStack{
                    Text("Your Rating")
                        .font(.title)
                        .foregroundStyle(.white)
                    RatingView(rating: $rating)
                }
                
                Spacer()
                 WebImage(url: URL(string: anime.images?.jpg.image_url ?? "N/A"))
                     .resizable()
                     .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                     .frame(maxWidth: 120, maxHeight: 180)
                     .shadow(radius: 3)
                     .scaledToFill()
            }.font(.title2)
                .padding(10)
                    
                .background(Color("barColor"))    // Color de fondo en azul
                
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            Text("Write your review (optional)")
            TextEditor(text: $comment)
                .scrollContentBackground(.hidden)
                .foregroundStyle(.white)
                .background(Color("barColor"))    // Color de fondo en azul
                .frame(maxHeight: 150) // Establece una altura mínima para mostrar múltiples líneas
                
             
                .cornerRadius(8) // Redondea las esquinas para un diseño más agradable
            HStack{
                Toggle("Spoiler", isOn: $spoiler)
                    .tint(Color.yellow)
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.yellow)
            }
                .foregroundStyle(.white)
                .font(.title2)
                    .padding(10)
                        
                    .background(Color("barColor"))    // Color de fondo en azul
                    
                        .clipShape(RoundedRectangle(cornerRadius: 10))

            HStack{
                Button(action: {
                    withAnimation {
                        sendReview = false
                    }
                    
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                Button(action: {
                    submitReview()
                    
                   
                    
                }) {
                    Text("Send")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                
              
                   
                    
            
               }.frame(maxWidth: .infinity)
                .font(.title2)
                    .padding(10)
                        
                    .background(Color("barColor"))    // Color de fondo en azul
                    
                        .clipShape(RoundedRectangle(cornerRadius: 10))
           
      Spacer()
        }.padding()
            .foregroundStyle(.white)
                    
        
    }
    
    func headerView() -> some View{
        HStack{
            
                if !sendReview && ((ratings?.ratings?.isEmpty) != nil) {
                    Text("\(ratings?.total_ratings ?? 0) Reviews")
                    Spacer()
                    Text("\(currentPage) of \(ratings?.total_pages ?? 0)")
                    HStack{
                        
                        Button(action: {
                            currentPage -= 1
                            loadData()
                            
                        }){
                            Image(systemName: "arrow.left.circle.fill")
                        }.disabled(currentPage == 1)
                        
                        Button(action: {
                            currentPage += 1
                            loadData()
                            
                        }){
                            Image(systemName: "arrow.right.circle.fill")
                        }.disabled(currentPage == ratings?.total_pages)
                        
                    }
                }
                
                
            
            }.font(.title3)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .background(Color("barColor"))
        
    }
    
    func submitReview() {
        let baseURL = "https://rayjewelry.us/animeLandiaApi/send_review.php"
        print("MMG")
      
        let urlString = "\(baseURL)?anime_id=\(anime.mal_id ?? 0)&user_id=\(AccountVm.sharedUserVM.userActual.first?.id ?? "")&rating=\(rating)&comment=\(comment)&spoiler=\(spoiler ? 1 : 0)"
        
        print(urlString)
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error en la solicitud: \(error)")
                } else {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Respuesta del servidor: \(responseString)")
                        withAnimation {
                            sendReview = false
                        }
                        loadData()
                    }
                }
            }.resume()
        }
    }

    
    func loadData() {
        
        // Realiza una solicitud HTTP para obtener las calificaciones
        AnimeVM.sharedAnimeVM.fetchRatingsForAnime(animeId:  anime.mal_id ?? 0, isAverage: false, page: String("\(currentPage)"), completion: {
            fetchedRatings in
            ratings = fetchedRatings
          
        })
        
    }
    
    // Función para formatear una fecha en una cadena de texto
    func formatDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: date) {
            let formattedDate = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
            return formattedDate
        }
        
        return "N/A"
    }
}

struct RatingView: View {
    @Binding var rating: Int

    var body: some View {
        HStack {
            ForEach(1..<6, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.cyan)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

#Preview {
    AnimeRatingDetailsView(anime: Anime.init(mal_id: 6033))
}
