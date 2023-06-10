//
//  MapView.swift
//  Pocket-Object
//
//  Created by 구본의 on 2023/06/10.
//

import SwiftUI
import MapKit
import SwiftData

extension CLLocationCoordinate2D {
  static let initLocation = CLLocationCoordinate2D(latitude: 37.50778658588244, longitude: 127.05954786689415)
}

extension MKCoordinateRegion {
  static var initRegion: MKCoordinateRegion {
    return .init(center: .initLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
  }
}


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
    
    // MARK: Capture
    @State private var presentCaptureView: Bool = false
    
    var body: some View {
        ZStack {
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
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentCaptureView = true
                    }) {
                        CircleButton(imageString: "camera")
                    }
                    .padding(.all)
                }
                Spacer()
            }
        }
        .sheet(isPresented: $presentCaptureView) {
            CapturePrimaryView {
                presentCaptureView = false
            }
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
//=======
//  @Query(sort: \.title, order: .forward, animation: .default) var allContent: [Content]
//  //    @State private var filteredContent: [Content] = []
//  
//  var bottomSheetViewModel = BottomSheetViewModel()
//  
//  @StateObject var locationDataManager = LocationDataManager()
//  @Namespace private var mapScope
//  
//  @Environment(\.modelContext) private var context
//  @Query private var markers: [Content]
//  
//  @State private var position: MapCameraPosition = .region(.initRegion)
//  //  @State private var mapSelection: MKMapItem?
//  @State private var selectedTag: Int?
//  @State private var selectedMarker: Content?
//  
//  @State private var showMarkerInfo: Bool = false
//  
//  @State private var isBottomSheetShow: Bool = false
//  
//  var body: some View {
//    Map(position: $position, selection: $selectedTag, scope: mapScope) {
//      
//      ForEach(Array(markers.enumerated()), id: \.offset) { offset, marker in
//        Marker(marker.title, systemImage: "suit.heart.fill", coordinate: CLLocationCoordinate2D(
//          latitude: Double(marker.lat) ?? 0.0,
//          longitude: Double(marker.log) ?? 0.0)
//        ).tag(offset)
//      }
//      
//      UserAnnotation()
//    }
//    .onAppear {
//      bottomSheetViewModel.contents = allContent
//      isBottomSheetShow.toggle()
//    }
//    .overlay(alignment: .bottomTrailing) {
//      VStack {
//        MapCompass(scope: mapScope)
//        MapPitchButton(scope: mapScope)
//        MapUserLocationButton(scope: mapScope)
//          .padding(.bottom, 320)
//          .padding(.trailing, 20)
//      }
//      .buttonBorderShape(.circle)
//      .padding()
//    }
//    .mapScope(mapScope)
//    .onChange(of: selectedTag) { tag in
//      guard let tag = tag else {
//        bottomSheetViewModel.contents = allContent
//        return
//      }
//      selectedMarker = markers[tag]
//      
//      if let selectedMarker = selectedMarker {
//        bottomSheetViewModel.contents = [selectedMarker]
//      }
//    }
//    .sheet(isPresented: $isBottomSheetShow, content: {
//      BottomSheetView(viewModel: bottomSheetViewModel)
//        .presentationDetents([.height(300)])
//        .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
//        .interactiveDismissDisabled(true)
//    })
//    .onAppear {
//      //      locationDataManager.getCurrentLocation()
//      //
//      //
//      //      
//      //
//      //
//      //
//      //      let newMaker = Content(imageUrl: "", date: Date.init(), title: "aaa", content: "bbb", lat: "37.51165285847918", log: "127.05760549475231", bookmark: true)
//      //
//      ////      selectedTag = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(newMaker.lat) ?? 0.0, longitude: Double(newMaker.log) ?? 0.0)))
//      //      context.insert(newMaker)
//      
//    }
//  }
//>>>>>>> acbbc7da1d426df03f32dbb893ea8905312b7288
}


#Preview {
    MapView()
}

