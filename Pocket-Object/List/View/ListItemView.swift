//
//  ListItemView.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI

struct ListItemView: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .padding()
            
            VStack {
                Text("2023.10.10")
                Text("Title")
                
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
    ListItemView()
}
