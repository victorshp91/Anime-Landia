//
//  AnimeWatchingButton.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 10/3/23.
//

import SwiftUI

struct AnimeWatchingButton: View {
    
    @State private var selectedOption = HelpersFunctions.animeWatchingOptions.completed
    
    @State private var iconImage: Image = Image(systemName: "")
    
     private var iconColor: Color {
        switch selectedOption {
        case .watching:
            return Color.blue
        case .completed:
            return Color.green
        case .hold:
            return Color.gray
        case .none:
            return .cyan
        }
    }
    
    private var icoImage: String {
        switch selectedOption {
        case .watching:
            return  "eye.circle.fill"
        case .completed:
            return "checkmark.circle.fill"
        case .hold:
            return "pause.circle.fill"
        case .none:
            return "plus.circle.fill"
        }
        
        
    }
    
    var body: some View {
        HStack{
            ZStack {
                Menu {
                    Button(action: {
                        selectedOption = .watching
                    }) {
                        Label("Watching", systemImage: "eye.circle.fill")
                            .foregroundStyle(.blue)
                    }
                    
                    Button(action: {
                        selectedOption = .completed
                        
                    }) {
                        Label("Completed", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                    
                    Button(action: {
                        selectedOption = .hold
                    }) {
                        Label("On Hold", systemImage: "pause.circle.fill")
                        
                    }
                    if selectedOption != .none{
                        Button(action: {
                            selectedOption = .none
                        }) {
                            Label("None", systemImage: "minus.circle.fill")
                            
                        }
                    }
                    
                } label: {
                    Image(systemName: icoImage).foregroundStyle(iconColor)
                        .font(.title)
                        .background(.white)
                }
            }
            Spacer()
        }.ignoresSafeArea()
    }
}

#Preview {
    AnimeWatchingButton()
}
