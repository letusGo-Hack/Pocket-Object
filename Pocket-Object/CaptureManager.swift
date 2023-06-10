//
//  CaptureManager.swift
//  Pocket-Object
//
//  Created by 김윤석 on 2023/06/10.
//
import RealityKit
import SwiftUI

// init -> ready -> detecting -> capture -> finishing -> completed

@MainActor
final class CaptureManager: ObservableObject {
    static let shared = CaptureManager()
    
    @Published var session = ObjectCaptureSession()
    
    private var configuration = ObjectCaptureSession.Configuration()
    
    func start() {
        configuration.checkpointDirectory = getDocumentsDirectory().appendingPathComponent("Snapshots/")
        configuration.isOverCaptureEnabled = true
        let url: URL = getDocumentsDirectory().appendingPathComponent("Images/")
        print(url.absoluteString)
        session.start(imagesDirectory: url, configuration: configuration)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private init() {}
}
