//
//  ListItemView.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI

struct ListItemView: View {
    var content: Content
    
    var body: some View {
        HStack {
            VStack {
                Text("\(content.date)")
                Text("\(content.title)")
                
                Spacer()
                
                HStack {
                    Button {
                        
                    } label: {
                        Text("bookmark")
                    }
                    
                    Button {
                        
                    } label: {
                        Text("share")
                    }
                }
                
            }
            
            Spacer()
            
            VStack(alignment: .center) {
                Button {
                    
                } label: {
                    Image(systemName: "greaterthan")
                }
                .frame(width: 40, height: 40)
            }
        }
        .padding()
    }
}

#Preview {
    Text("")
}


