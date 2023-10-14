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
    @State private var rating = 0
    @State private var comment = ""
    @State private var spoiler = false // Inicialmente, no es spoiler
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            if !sendReview {
                headerView()
            }
                // FORMULARIO PARA ENVIAR REVIEW
                ZStack(alignment:.center) {
                
                    if let rating = ratings?.ratings {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    ForEach(rating, id: \.id) { rating in
                        VStack(alignment: .leading, spacing: 10) {
                            
                            HStack{
                                Spacer()
                                Button(action:{
                                    
                                }){
                                    Image(systemName: "x.circle.fill")
                                        .foregroundStyle(.red)
                                        .font(.title2)
                                }
                            }
                            HStack{
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
                            }
                            
                            Text("\(rating.comment ?? "N/A")")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                       
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }.opacity(sendReview == true ? 0:1)
                    } else {
                        if !sendReview  {
                            Text("No Ratings Yet")
                                .font(.headline)
                            
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth:.infinity)
                                .background(.cyan)
                        }
                    }
                    if sendReview {
                        formSendRiview()
                    }
            }
            
            Spacer()
        } .background(Color.gray.opacity(0.1))
        

        .onAppear {
            loadData()
        }
    }
    
    func formSendRiview() -> some View {
        VStack(spacing: 10) {
                   Text("Insertar una nueva reseña")
                       .font(.title)
                    
                    RatingView(rating: $rating)

                   TextField("Comment", text: $comment)
                       .textFieldStyle(RoundedBorderTextFieldStyle())

                   Toggle("Contiene Spoilers", isOn: $spoiler)

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
           
            WebImage(url: URL(string: anime.images?.jpg.image_url ?? "N/A"))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                .frame(maxWidth: 200, maxHeight: 280)
                .shadow(radius: 3)
                .scaledToFill()
      Spacer()
        }.padding()
                    
        
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
            // BOTON FOR ANIME TYPE SEARCH
            Button(action: {
                withAnimation {
                    sendReview = true
                }
            }){
                Image(systemName: "plus.message.fill")
                    .font(.title2)
            }
            
        }.font(.title3)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .padding()
            .background(.cyan)
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
