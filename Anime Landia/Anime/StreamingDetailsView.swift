//
//  StreamingDetailsView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI

struct StreamingDetailsView: View {
    @State private var streams: [Streams] = []
    let animeId: Int
    
    var body: some View {
        VStack{
            if !streams.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(streams, id: \.self) { stream in
                            HStack{
                                Button(action: {
                                    if let url = URL(string: stream.url) {
                                        UIApplication.shared.open(url)
                                    }
                                }){
                                    HStack{
                                        Image(systemName: "play.circle.fill")
                                        Text(stream.name)
                                    }
                                }
                            }.padding()
                                
                                .background(Color("accountNavColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                .foregroundStyle(.white)
                        }
                    }
                    
                }
            } else {
                Text("NO AVAILABLE")
            }
        }.onAppear(perform: {
            loadData()
        })
    }
    
    func loadData() {
        guard let url = URL(string: "https://api.jikan.moe/v4/anime/\(animeId)/streaming") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(StreamData.self, from: data)
                    DispatchQueue.main.async {
                        self.streams = decodedData.data
                    }
                } catch {
                    print("Error al decodificar los datos: \(error)")
                }
            } else if let error = error {
                print("Error al cargar los datos: \(error)")
            }
        }.resume()
    }
    
    struct StreamData: Codable{
        var data: [Streams]
    }
    
    struct Streams: Codable, Hashable {
        let name: String
        let url: String
    }
}

#Preview {
    StreamingDetailsView(animeId: 53998)
}
