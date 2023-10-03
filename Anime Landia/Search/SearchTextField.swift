//
//  SearchView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/1/23.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var searchingText: String
    
    var body: some View {
        
        TextField("By Name", text: $searchingText)
            .disableAutocorrection(true)
            .padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 20))
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        
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
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 10)
                                .font(.title2)
                        })
                    }
                }
            )
        
    }
}

#Preview {
    SearchTextField(searchingText: Binding.constant(""))
}
