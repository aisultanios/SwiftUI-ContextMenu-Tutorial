//
//  ContentView.swift
//  ContextMenuTutorial
//
//  Created by Aisultan Askarov on 11.03.2023.
//

import SwiftUI

struct ContentView: View {
        
    @State private var text: String = "GREEN"
    @State private var color: Color = .green
    @State private var currentColorHex: String = "33C758"
    
    var body: some View {
        
        let greenAction = UIAction(
            
                title: "Set Green",
                identifier: nil,
                handler: { _ in
                    text = "GREEN"
                    color = .green
                    currentColorHex = getHexCode(color: color)
                }
                
            )
        
        let redAction = UIAction(
            
                title: "Set Red",
                identifier: nil,
                handler: { _ in
                    text = "RED"
                    color = .red
                    currentColorHex = getHexCode(color: color)
                }
                
            )
        
        if #available(iOS 16.0, *) {
            CustomRectangle(size: CGSize(width: 100, height: 100), isPreview: false, color: $color, text: $text, currentColorHex: $currentColorHex)
                .contextMenu {
                    //Our context Menu actions selection
                    Button(action:{
                        self.text = "RED"
                        self.color = .red
                        currentColorHex = getHexCode(color: color)
                    }){
                        Text("Set Red")
                    }
                    Button(action:{
                        self.text = "GREEN"
                        self.color = .green
                        currentColorHex = getHexCode(color: color)
                    }){
                        Text("Set Green")
                    }
                    //
                } preview: {
                    CustomRectangle(size: CGSize(width: 250, height: 150), isPreview: true, color: $color, text: $text, currentColorHex: $currentColorHex)
                }
        } else {
            // Fallback on earlier versions
            CustomRectangle(size: CGSize(width: 100, height: 100), isPreview: false, color: $color, text: $text, currentColorHex: $currentColorHex)
                .contextMenu(PreviewContextMenu(size: CGSize(width: 250, height: 150), color: $color, text: $text, destination: CustomRectangle(size: CGSize(width: 250, height: 150), isPreview: true, color: $color, text: $text, currentColorHex: $currentColorHex), actionProvider: { items in
                    return UIMenu(title: "", children: [greenAction, redAction])
                }))

        }

        
    }
    
    func getHexCode(color: Color) -> String {
        
        let ciColor = CIColor(color: UIColor(color))
        let red = ciColor.red
        let blue = ciColor.blue
        let green = ciColor.green
        
        // Create a hex code string from the RGB components
        let hexCode = String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        
        print(hexCode)
        return hexCode
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
