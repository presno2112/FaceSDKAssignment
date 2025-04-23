//
//  ContentView.swift
//  FaceSDKAssignment
//
//  Created by Sebastian Presno on 22/04/25.
//

import SwiftUI
import PhotosUI

struct MainView: View {
  @State private var isSecondButtonEnabled = false
  @State private var isFirstButtonGreen = false
  @State private var isSecondButtonGreen = false
  @State private var showPhotoPicker = false
  @State private var pickerItem: PhotosPickerItem?
  @State private var face = FaceOO()
  @State private var showResults = false
  @State private var resultPercentage: Double = 0.0
  
  var body: some View {
    if showResults{
      ResultsView(targetPercentage: 75.0)
    }
    else{
      VStack {
        HStack {
          Button {
            face.showFaceCapture()
            isFirstButtonGreen = true
            isSecondButtonEnabled = true
          } label: {
            ActionButton(text: "Take a picture!", isPhoto: false, isActionDone: $isFirstButtonGreen)
          }
          
          Button {
            if !isSecondButtonEnabled {
              isSecondButtonEnabled = true
              isFirstButtonGreen = true
              
            } else {
              showPhotoPicker = true
              isSecondButtonGreen = true
            }
          }label: {
            ActionButton(text: "Choose a picture!", isPhoto: true, isActionDone : $isSecondButtonGreen)
          }
          .disabled(!isSecondButtonEnabled)
          .opacity(isSecondButtonEnabled ? 1.0 : 0.5)
        }
        .padding()
        
        
        Button {
          isSecondButtonEnabled = false
          isFirstButtonGreen = false
          isSecondButtonGreen = false
          face.selectedImage = nil
          face.faceCaptureResponse = nil
          
        }label: {
          Text("Start Over")
        }
        .padding(.top, 80)
        Button {
          face.matchFace()
          resultPercentage = 95.0
          showResults = true
          
        }label: {
          Text("Check Results")
        }
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
    }
  }
}

#Preview {
  MainView()
}
