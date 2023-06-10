//
//  ListItemView.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI

struct ListItemView: View {
    @State var bounceValue: Int = 0
    
    var content: Content
    var isBookMartStateChange: (() -> Void)
    
    let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월 d일"
        return formatter
    }()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                Text("\(content.title)")
                    .font(.title)
                
                Text("\(content.date, formatter: dateformat)")
                    .font(.subheadline)
                
                Spacer()
                
                HStack {
                    Button {
                        self.isBookMartStateChange()
                        //                        content.bookmark.toggle()
                    } label: {
                        Image(systemName: content.bookmark ? "bookmark.fill" : "bookmark")
                            .contentTransition(.symbolEffect(.replace.offUp))
                    }
                    
                    Button {
                        bounceValue += 1
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .symbolEffect(.bounce, value: bounceValue)
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


