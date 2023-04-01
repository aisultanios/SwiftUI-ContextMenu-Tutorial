//
//  CustomRectangle.swift
//  ContextMenuTutorial
//
//  Created by Aisultan Askarov on 12.03.2023.
//

import SwiftUI

struct CustomRectangle: View {
    
    @State var size: CGSize
    @State var isPreview: Bool
    
    @Binding var color: Color
    @Binding var text: String
    @Binding var currentColorHex: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: size.width, height: size.height)
            .foregroundColor(color)
            .overlay {
                VStack(alignment: .leading, spacing: 5) {
                    Text(text)
                        .foregroundColor(.white)
                        .font(isPreview ? .title: .title2)
                        .cornerRadius(10)
                        .shadow(radius: 3.5)
                        .frame(width: 100, height: 40)
                    
                    if isPreview {
                        Text(currentColorHex)
                            .foregroundColor(.white.opacity(0.75))
                            .font(.title2)
                            .cornerRadius(10)
                            .shadow(radius: 3.5)
                            .frame(width: 100, height: 40)
                    }
                }
            }
    }
}


