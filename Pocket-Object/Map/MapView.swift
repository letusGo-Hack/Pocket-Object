//
//  MapView.swift
//  Pocket-Object
//
//  Created by 구본의 on 2023/06/10.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @Query(sort: \.title, order: .forward, animation: .default) var allContent: [Content]
    //    @State private var filteredContent: [Content] = []
    
    var bottomSheetViewModel = BottomSheetViewModel()
    
    @StateObject var locationDataManager = LocationDataManager()
    @Namespace private var mapScope
    
    @Environment(\.modelContext) private var context
    @Query private var markers: [Content]
    
    @State private var position: MapCameraPosition = .automatic
    //  @State private var mapSelection: MKMapItem?
    @State private var selectedTag: Int?
    @State private var selectedMarker: Content?
    
    @State private var showMarkerInfo: Bool = false
    
    @State private var isBottomSheetShow: Bool = false
    
    var body: some View {
        Map(position: $position, selection: $selectedTag, scope: mapScope) {
            
            ForEach(Array(markers.enumerated()), id: \.offset) { offset, marker in
                Marker(marker.title, systemImage: "suit.heart.fill", coordinate: CLLocationCoordinate2D(
                    latitude: Double(marker.lat) ?? 0.0,
                    longitude: Double(marker.log) ?? 0.0)
                ).tag(offset)
            }
            
            UserAnnotation()
        }
        .onAppear {
            bottomSheetViewModel.contents = allContent
            isBottomSheetShow.toggle()
        }
        .overlay(alignment: .bottomTrailing) {
            VStack {
                MapCompass(scope: mapScope)
                MapPitchButton(scope: mapScope)
                MapUserLocationButton(scope: mapScope)
            }
            .buttonBorderShape(.circle)
            .padding()
        }
        .mapScope(mapScope)
        .onChange(of: selectedMarker) {
            guard let selectedMarker = selectedMarker else { return }
            
            bottomSheetViewModel.contents = [selectedMarker]
        }
        .onChange(of: selectedTag) { tag in
            
            
            selectedMarker = markers[tag ?? 0]
            //      print(markers[tag])
            
            
            //      showMarkerInfo = true
            
        }
        .sheet(isPresented: $presentObjectDetailView, content: {
            ObjectDetailView(content: selectedContent, tapDismiss: {
                self.presentObjectDetailView = false
            })
            .interactiveDismissDisabled()
        })
        .sheet(isPresented: $isBottomSheetShow, content: {
            BottomSheetView(
                viewModel: bottomSheetViewModel,
                onTap: { content in
                    selectedContent = content
                    presentObjectDetailView = true
                })
            .presentationDetents([.height(100), .medium, .large])
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled(true)
        })
        .sheet(isPresented: $showMarkerInfo, onDismiss: {
            withAnimation(.snappy) {
                //        if let boudingRect = route?.polyline.boundingMapRect, routeDisplaying {
                //          cameraPosition = .rect(boudingRect)
                //        }
            }
        }, content: {
            mapDetails()
                .presentationDetents([.height(300)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                .interactiveDismissDisabled(true)
        })
        .onAppear {
            locationDataManager.getCurrentLocation()
            //Set Dummy Data
            let newMaker = Content(imageUrl: "", date: Date.init(), title: "aaa", content: "bbb", lat: "37.51165285847918", log: "127.05760549475231", bookmark: true)
            context.insert(newMaker)
        }
    }
    
    @State private var selectedContent: Content?
    
    @State private var presentObjectDetailView = false
    
    @ViewBuilder
    func mapDetails() -> some View {
        VStack(spacing: 15, content: {
            
            ZStack {
                
            }
            .frame(height: 200)
            .clipShape(.rect(cornerRadius: 15))
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    showMarkerInfo = false
                    withAnimation(.snappy) {
                        //            mapSelection = nil
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.black)
                        .background(.white, in: .circle)
                })
                .padding(10)
            }
            
            Button(action: {}, label: {
                Text("DIRECT")
            })
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.blue.gradient, in: .rect(cornerRadius: 15))
            
            
        })
        .padding(15)
    }
}


#Preview {
    MapView()
}

