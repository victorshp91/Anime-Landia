//
//  SearchView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/1/23.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var searchingText: String
    var onSearch: () -> Void // Cierre para la acción de búsqueda
    var onChange: () -> Void // Cierre para la acción de búsqueda
    var body: some View {
        
        TextField("By Name", text: $searchingText)
            .disableAutocorrection(true)
            .padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 20))
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .onSubmit {
                                // Ejecuta el cierre para la acción de búsqueda desde la vista secundaria
                                onSearch()
                            }
            .onChange(of: searchingText) {
                onChange()
            }
        
            .overlay(
                HStack {
                    
                    Image(systemName: "magnifyingglass.circle.fill")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .font(.title2)
                    
                    Spacer()
                    if !searchingText.isEmpty {
                        Button(action: {
                            searchingText = ""
                        }, label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: 50, alignment: .trailing)
                                .padding(.trailing, 10)
                                .font(.title2)
                        })
                    }
                }
            )
        
    }
}

#Preview {
    SearchTextField(searchingText: Binding.constant(""), onSearch: {}, onChange: {})
}
