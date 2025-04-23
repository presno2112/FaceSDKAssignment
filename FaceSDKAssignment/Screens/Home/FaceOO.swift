//
//  MainOO.swift
//  FaceSDKAssignment
//
//  Created by Sebastian Presno on 22/04/25.
//

import Foundation
import Combine
import FaceSDK
import PhotosUI
import SwiftUI


@MainActor
@Observable
class FaceOO {
  var isInitialized: Bool = false
  var livenessResponse: LivenessResponse?
  var livenessResultsReady: Bool = false
  var similarityScore: Double?
  var faceCaptureResponse: FaceCaptureResponse? {
    didSet {
      faceCaptureResultsReady = faceCaptureResponse != nil
    }
  }
  
  var matchFaceResponse : MatchFacesResponse?{
    didSet{
      matchFaceResponseReady = matchFaceResponse != nil
      
      if let similarity = matchFaceResponse?.results.first?.similarity?.doubleValue {
        self.similarityScore = similarity
        print("Similarity Score Updated: \(similarity)")
      } else {
        self.similarityScore = nil
      }
      
    }
  }
  
  var faceCaptureResultsReady: Bool = false
  var matchFaceResponseReady: Bool = false
  
  var selectedImage: UIImage?
  
  private var cancellables: Set<AnyCancellable> = .init()
  
  init() {
    setup()
  }
  
  func setup() {
    FaceSDK.service.initializeFace().sink { [unowned self] completion in
      switch completion {
      case .finished:
        self.isInitialized = true
      case .failure(let error):
        print(error.localizedDescription)
      }
    } receiveValue: { _ in
      
    }.store(in: &cancellables)
  }
  
  func showFaceCapture() {
    guard let presenter = UIApplication.shared.rootViewController else {
      return
    }
    
    FaceSDK.service.presentFaceCaptureViewController(from: presenter, animated: true) { response in
      self.faceCaptureResponse = response
    }
  }
  
  func matchFace(){
    guard let capturedImage = faceCaptureResponse?.image?.image,
          let selectedImage = selectedImage else {
      print("Both images are required for face matching.")
      return
    }
    
    let images = [
      MatchFacesImage(image: capturedImage, imageType: .live),
      MatchFacesImage(image: selectedImage, imageType: .live)
    ]
    
    let request = MatchFacesRequest(images: images)
    
    FaceSDK.service.matchFaces(request, completion: { response in
      DispatchQueue.main.async {
        self.matchFaceResponse = response
        if let similarity = response.results.first?.similarity?.doubleValue {
          print("Similarity Score: \(similarity)")
        } else {
          print("Failed to compute similarity.")
        }
      }
    })
  }
  
  func showLiveness() {
    guard let presenter = UIApplication.shared.rootViewController else {
      return
    }
    
    // Apply some configuration
    let configuration = LivenessConfiguration {
      $0.attemptsCount = 2
      $0.stepSkippingMask = [.onboarding, .success]
    }
    
    FaceSDK.service.startLiveness(from: presenter, animated: false, configuration: configuration) { response in
      self.livenessResponse = response
    }
  }
}

extension FaceSDK {
  
  func initializeFace() -> AnyPublisher<Bool, Error> {
    Deferred {
      Future<Bool, Error> { promise in
        FaceSDK.service.initialize() { success, error in
          if let error = error {
            promise(.failure(error))
          } else {
            promise(.success(success))
          }
        }
      }
    }.eraseToAnyPublisher()
  }
}
