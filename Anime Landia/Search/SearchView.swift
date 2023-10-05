//
//  SearchView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/1/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    
    @State var searchText = ""
    
    @State var isSearching = false
    @State var currentPage = 1
    @State var selectedAnimeType = HelpersFunctions.filtreAnimeType.all
    @State var isShowingPagination = false
    @State private var selectedOption = HelpersFunctions.searchingType.anime // Inicialmente seleccionamos la primera opción que es anime
    // para guardar la data de los characteres devueltos
    
    
    @State private var characterData: [CharacterStruct.AnimeCharacter]?
    @State private var animeData: [Anime]?
    @State private var pagination: Pagination?
    
    var body: some View {
        
        VStack(spacing: 0){
            
            SearchTextField(searchingText: $searchText, onSearch: {
                
                currentPage = 1
                withAnimation {
                    isShowingPagination = true
                }
                if selectedOption == .character {
                   
                    loadCharacteres()
                } else {
          
                    loadAnimes()
                }
               
            }).padding(.bottom)
            if isShowingPagination {
                if let paginationData = pagination {
                    HStack{
                        Text("Results")
                        Text("\(paginationData.items.total)")
                            .bold()
                        
                        Spacer()
                        Text("\(currentPage) of \(paginationData.last_visible_page)")
                        HStack{
                            
                            Button(action: {
                                currentPage -= 1
                                if selectedOption == .character {
                                    loadCharacteres()
                                } else {
                                    loadAnimes()
                                }
                            }){
                                Image(systemName: "arrow.left.circle.fill")
                            }.disabled(currentPage == 1)
                            
                            Button(action: {
                                currentPage += 1
                                if selectedOption == .character {
                                    loadCharacteres()
                                } else {
                                    loadAnimes()
                                }
                            }){
                                Image(systemName: "arrow.right.circle.fill")
                            }.disabled(!paginationData.has_next_page)
                            
                        }
                        // BOTON FOR ANIME TYPE SEARCH
                        
                        if selectedOption == .anime && !(animeData?.isEmpty ?? true) {
                         
                                
                                // Botón que presenta el menú
                                Picker("Select type anime", selection: $selectedAnimeType) {
                                    ForEach(HelpersFunctions.filtreAnimeType.allCases) { option in
                                        Text(option.rawValue.capitalized)
                                            .tag(option)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle()) // Use MenuPickerStyle to create a menu-like segmented control
                                .onChange(of: selectedAnimeType) {
                                    // vulve a la primera pagina
                                    currentPage = 1
                                    // carga los animes
                                    loadAnimes()
                                    
                                }
                                
                                
                            
                        }
                        
                    }.font(.title3)
                        .padding(.bottom)
                }
            }
            Picker("Select Filter", selection: $selectedOption) {
                ForEach(HelpersFunctions.searchingType.allCases) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            } .pickerStyle(SegmentedPickerStyle()) // Estilo de segmento
                .onChange(of: selectedOption) {
                                // Aquí puedes realizar la acción que deseas cuando se selecciona una opción
                    isSearching = false
                    searchText = ""
                    selectedAnimeType = .all
                    
                    withAnimation{
                        isShowingPagination = false
                        animeData = []
                        characterData = []
                    }
                    
                                
                            }
            
         
            
            
            // MUESTRO LOS CARACTERES SI ES ESO QUE S EBUSCA
            ScrollView(.vertical, showsIndicators: false){
                
            if selectedOption == .character {
                
                if let characteres = characterData {
                    characterListView(characters: characteres)
                }else {
                    if isSearching {
                        HelpersFunctions().loadingView()
                    }
                }
            } else {
                
                if let animes = animeData {
                    
                    animeListView(animes: animes)
                   
                }else {
                    if isSearching {
                        HelpersFunctions().loadingView()
                    }
                }
                
            }
            }.font(.subheadline)
            Spacer()
        }.navigationTitle("Search")
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .navigationBarTitleDisplayMode(.large)
            
        
    }
    
    // VISTA DE LA LISTA DE LOS CHARACTERES
    
    func characterListView(characters: [CharacterStruct.AnimeCharacter]) -> some View {
        LazyVStack(alignment:.leading, spacing: 10){
            ForEach(characters) { character in
                NavigationLink(destination: CharacterDetailsView(character: character)) {
                    HStack(alignment: .top){
                        WebImage(url: URL(string: character.images?.jpg.image_url ?? "NO DATA"))
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                            .frame(maxWidth: 100, maxHeight: 150)
                            .scaledToFit()
                        VStack(alignment: .leading, spacing: 5){
                            Text("\(character.name ?? "N/A")")
                                .multilineTextAlignment(.leading)
                                .font(.callout)
                                .bold()
                            Text("\(character.about ?? "N/A")")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(5)
                        }
                            
                       Spacer()
                    }.foregroundStyle(.black)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                       
                       
                }
            }
        }.padding(.horizontal)
            .padding(.top)
    }
    
    // VISTA DE LA LISTA DE LOS ANIMES
    
    func animeListView(animes: [Anime]) -> some View {
        
        LazyVStack(alignment:.leading, spacing: 10){
            ForEach(animes) { anime in
                ZStack(alignment:.topTrailing) {
                    NavigationLink(destination: AnimeDetailsView(anime: anime)) {
                        HStack(alignment: .top){
                            
                            WebImage(url: URL(string: anime.images?.jpg.image_url ?? "NO DATA"))
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                .frame(maxWidth: 120, maxHeight: 150)
                                .scaledToFill()
                            
                            
                            
                            VStack(alignment: .leading){
                                
                                HStack{
                                    Text("\(anime.type ?? "N/A")")
                                        .padding(5)
                                        .background(.red)
                                        .foregroundStyle(.white)
                                    Text("\(String(anime.episodes ?? 0)) Ep.")
                                    
                                    
                                }
                                VStack(alignment:.leading){
                                    Text("\(anime.title ?? "N/A")").bold()
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow)
                                        Text(String(format: "%.2f", anime.score ?? 0)).bold()
                                    }
                                }.padding(.horizontal,3)
                            }
                            Spacer()
                        }.foregroundStyle(.black)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        
                        
                        
                    }
                    
                    AnimeWatchingButton(animeId: anime.mal_id ?? 0, changeOptionImageSize: 15)
                }
            }
        }.padding(.horizontal)
            .padding(.top)
        
    }
    
    func loadCharacteres() {
        isSearching = true
        guard let url = URL(string: "https://api.jikan.moe/v4/characters?q=\(searchText)&sort=desc&order_by=favorites&page=\(currentPage)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(CharacterStruct.CharacterData.self, from: data)
                    DispatchQueue.main.async {
                        self.characterData = decodedData.data
                        self.pagination = decodedData.pagination
                    }
                } catch {
                    print("Error al decodificar los datos: \(error)")
                }
            } else if let error = error {
                print("Error al cargar los datos: \(error)")
            }
        }.resume()
    }
    
    func loadAnimes() {
        isSearching = true
        // si el type de anime es all entonces el link es sin type
        guard let url = URL(string: selectedAnimeType == .all ? "https://api.jikan.moe/v4/anime?q=\(searchText)&sort=desc&order_by=favorites&page=\(currentPage)" : "https://api.jikan.moe/v4/anime?q=\(searchText)&sort=desc&order_by=favorites&page=\(currentPage)&type=\(selectedAnimeType.rawValue.lowercased())") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(AnimeData.self, from: data)
                    DispatchQueue.main.async {
                        self.animeData = decodedData.data
                        self.pagination = decodedData.pagination
                    }
                } catch {
                    print("Error al decodificar los datos: \(error)")
                }
            } else if let error = error {
                print("Error al cargar los datos: \(error)")
            }
        }.resume()
    }
}

#Preview {
    SearchView()
}
