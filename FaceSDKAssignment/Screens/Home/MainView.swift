//
//  ContentView.swift
//  FaceSDKAssignment
//
//  Created by Sebastian Presno on 22/04/25.
//

import SwiftUI
import PhotosUI

struct MainView: View {
  @State private var showPhotoPicker = false
  @State private var pickerItem: PhotosPickerItem?
  @State private var face = FaceOO()
  @State private var showResults = false
  @State private var resultPercentage: Double = 0.0
  @State private var isLoading = false
  
  var body: some View {
    if showResults{
      ResultsView(face: $face, showResults: $showResults, targetPercentage: resultPercentage)
    }
    else{
      ZStack {
        VStack {
          HStack {
            Button {
              face = FaceOO()
              print("Initialized again")
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                face.showFaceCapture()
              }
            } label: {
              ActionButton(text: "Take a picture!", isPhoto: false, isActionDone: face.isFaceCaptured)
            }
            .disabled(face.isFaceCaptured)
            
            Button {
              showPhotoPicker = true
            } label: {
              ActionButton(text: "Choose a picture!", isPhoto: true, isActionDone: face.selectedImage != nil)
            }
            .disabled(!face.isFaceCaptured || face.selectedImage != nil)
            .opacity(face.isFaceCaptured ? 1.0 : 0.5)
          }
          .padding()
          
          
          Button {
            face.deinitialize()
            face.selectedImage = nil
            face.faceCaptureResponse = nil
            face.isFaceCaptured = false
            pickerItem = nil
            
          }label: {
            ZStack{
              RoundedRectangle(cornerRadius: 20)
                .frame(width: 150, height: 50)
              Text("Start Over")
                .foregroundStyle(.white)
            }
          }
          .padding()
          Button {
            isLoading = true
            face.matchFace { similarity in
              isLoading = false
              if let similarity = similarity {
                resultPercentage = similarity * 100
                showResults = true
              } else {
                print("No similarity score available.")
              }
            }
            pickerItem = nil
          } label: {
            ZStack {
              RoundedRectangle(cornerRadius: 20)
                .frame(width: 150, height: 50)
                .foregroundStyle(face.selectedImage == nil ? .gray : .green)
              Text("Check results")
                .foregroundStyle(.white)
            }
          }
          .disabled(face.selectedImage == nil)
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $pickerItem)
        .onChange(of: pickerItem) {
          guard let item = pickerItem else { return }
          
          item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
              switch result {
              case .success(let data):
                if let data = data, let uiImage = UIImage(data: data) {
                  face.selectedImage = uiImage
                } else {
                  print("Failed to convert data to UIImage")
                }
              case .failure(let error):
                print("Error loading image: \(error)")
              }
            }
          }
        }
        .padding()
        if isLoading {
          Color.black.opacity(0.4)
            .ignoresSafeArea()
          ProgressView("Matching Faces...")
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
            .foregroundColor(.white)
        }
      }
    }
  }
}

#Preview {
  MainView()
}
