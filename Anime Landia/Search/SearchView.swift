//
//  SearchView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/1/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    
    @State private var historySearch: [String] = [] // PARA GAURDAR EL HISTORIAL LAS BUSQUEDAS
    
    @State var searchText = ""
    
    @State var isSearching = false
    @State var currentPage = 1
    @State var selectedAnimeType = HelpersFunctions.filtreAnimeType.all
    @State var isShowingPagination = false
    @State private var selectedOption = HelpersFunctions.searchingType.anime // Inicialmente seleccionamos la primera opción que es anime
    // para guardar la data de los characteres devueltos
    @State private var showHistory = true
    let maxSearchSize = 10 // Establece el límite de elementos
    @State private var characterData: [CharacterStruct.AnimeCharacter]?
    @State private var animeData: [Anime]?
    @State private var pagination: Pagination?
    @State private var ratingAverage = [String:Double]() // LOS USO PARA GUARDAR EL RATING PARA LOS ANIMES QUE SE ESTAN PRESENTANDO EN LA BUSQUEDA. TIEN EL ID DEL ANIME COMO KEY Y EL RATING COMO VALUE
    
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        VStack(spacing: 0){
            ScrollView(.vertical, showsIndicators: false){
                
                SearchTextField(searchingText: $searchText, onSearch: {
                    
                    addNewSearch()
                    
                    currentPage = 1
                    withAnimation {
                        isShowingPagination = true
                    }
                    if selectedOption == .character {
                        
                        loadCharacteres()
                    } else {
                        
                        loadAnimes()
                    }
                    withAnimation {
                        showHistory = false
                    }
                    
                }, onChange: {
                    if searchText.isEmpty {
                        animeData = []
                        characterData = []
                        withAnimation {
                            isShowingPagination = false
                            showHistory = true
                        }
                    }
                }, by: "name")
                    .padding(.top)
                // SI PRESENTA HISTORY SI NO TODO NORMAL
                if showHistory {
                    
                    VStack(alignment: .leading, spacing: 20){
                        HStack{
                            
                            Text("Search History")
                            Spacer()
                            Button(action: {deleteItemHistory()}) {
                                Image(systemName: "x.circle.fill")
                                    
                            }
                        }.foregroundStyle(.white)
                            .font(.title2)
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 10){
                                ForEach(historySearch.reversed(), id: \.self) { item in
                                    Button(action: {
                                        searchText = item
                                        withAnimation {
                                            showHistory = false
                                            
                                            isShowingPagination = true
                                        }
                                        if selectedOption == .anime {
                                            loadAnimes()
                                        } else {
                                            loadCharacteres()
                                        }
                                    }) {
                                        HStack{
                                            Image(systemName: "clock.arrow.2.circlepath")
                                            Text(item)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
   
                } else {
                    
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
                                    
                                }.disabled(selectedOption == .anime ? false:true)
                                
                                
                                
                                
                                
                            }.font(.title3)
                           
                                .foregroundStyle(.white)
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
                            withAnimation {
                                isSearching = false
                            }
                            characterData = []
                            animeData = []
                            selectedAnimeType = .all
                            currentPage = 1
                            if selectedOption == .anime {
                                loadAnimes()
                            } else {
                                loadCharacteres()
                            }
                            
                        }
                    
                    // MUESTRO LOS CARACTERES SI ES ESO QUE S EBUSCA
                    
                    
                    
                    
                    if selectedOption == .character {
                        
                        if let characteres = characterData {
                            characterListView(characters: characteres)
                        }else {
                            if isSearching {
                                CustomLoadingView().padding() // Muestra el indicador de carga personalizado
                            }
                        }
                    } else {
                        
                        if let animes = animeData {
                            
                            animeListView(animes: animes, ratingAverage: ratingAverage )
                            
                        }else {
                            if isSearching {
                                CustomLoadingView().padding() // Muestra el indicador de carga personalizado
                            }
                        }
                        
                    }
                }}.font(.subheadline)
            
      
            
        
        }
            .padding(.horizontal)
            .background(Color("background"))
           
            .onAppear(perform: {
                loadHistory()
                
            })
            
        
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
                    }.foregroundStyle(.white)
                        .background(Color("barColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                       
                       
                }
            }
        }
           
    }
    
    // VISTA DE LA LISTA DE LOS ANIMES
    
    func animeListView(animes: [Anime], ratingAverage: [String:Double]) -> some View {
        
        LazyVStack(alignment:.leading, spacing: 10){
            ForEach(animes, id: \.mal_id) { anime in
                
                    NavigationLink(destination: AnimeDetailsView(anime: anime)) {
                        HStack(alignment: .top){
                            ZStack(alignment: .topLeading) {
                                WebImage(url: URL(string: anime.images?.jpg.image_url ?? "NO DATA"))
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                    .frame(maxWidth: 110, maxHeight: 150)
                                    .scaledToFill()
                                Text("\(anime.type ?? "N/A")")
                                    .padding(5)
                                    .background(.red)
                                    .foregroundStyle(.white)
                            }
                                
                            
                            
                            VStack(alignment: .leading){
                                
                        
                                VStack(alignment:.leading){
                                    Text("\(anime.title ?? "N/A")").bold()
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    HStack{
                                        Text("\(String(anime.episodes ?? 0)) Episodes")
                                            
                                        Spacer()
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.cyan)
                                     
                                        Text(String(format: "%.1f", ratingAverage["\(anime.mal_id ?? 0)"] ?? 0.0))
                                    }.padding(.bottom, 5)
                                        .font(.title2).bold()
                                }.padding(.horizontal,3)
                            }
                            Spacer()
                        }.foregroundStyle(.white)
                            .background(Color("barColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        
                        
                        
                    }
                    
                 
                
            }
        }
        
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
        withAnimation {
            isSearching = true
        }
        // si el type de anime es all entonces el link es sin type
        guard let url = URL(string: selectedAnimeType == .all ? "https://api.jikan.moe/v4/anime?q=\(searchText)&sort=desc&order_by=favorites&page=\(currentPage)&sfw=true" : "https://api.jikan.moe/v4/anime?q=\(searchText)&sort=desc&order_by=favorites&page=\(currentPage)&type=\(selectedAnimeType.rawValue.lowercased())&sfw=true") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            ratingAverage = [:]
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(AnimeData.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.animeData = decodedData.data
                        self.pagination = decodedData.pagination
                        
                        // AGREGO EL RATING DE CADA ANIME POR EL ID EN EL ARREGLO DECLARADO ARRIBA QUE ES UN DICCIONARIO QUE CONTIENE EL ID DEL ANIME Y EL RATING
                        
                        if let animes = animeData{
                            for anime in animes{
                                AnimeVM.sharedAnimeVM.fetchRatingsForAnime(animeId: anime.mal_id ?? 0, isAverage: true, page: "1", completion: { rating in
                                    if let average = rating.average{
                                        ratingAverage["\(anime.mal_id ?? 0)"] = average
                                    }
                                    
                                    
                                })
                            }
                        }
                        
                    }
                   
                    
                } catch {
                    print("Error al decodificar los datos: \(error)")
                }
            } else if let error = error {
                print("Error al cargar los datos: \(error)")
            }
        }.resume()
    }
    
    private func addNewSearch() {
        if historySearch.count >= maxSearchSize {
                    // Si el array ha alcanzado el límite, elimina el elemento más antiguo
            historySearch.removeFirst()
                }
        historySearch.append(searchText)
                        saveHistory()
    }
    
    // Función para cargar los datos desde UserDefaults
        private func loadHistory() {
            if let savedStringArray = UserDefaults.standard.array(forKey: "historySearch") as? [String] {
                historySearch = savedStringArray
            }
        }
    
    // Función para guardar los datos en UserDefaults
        private func saveHistory() {
            UserDefaults.standard.set(historySearch, forKey: "historySearch")
        }
    
    // Función para eliminar un elemento de la lista hisotru
        private func deleteItemHistory() {
            historySearch.removeAll()
            saveHistory()
        }
}

#Preview {
    SearchView()
}
