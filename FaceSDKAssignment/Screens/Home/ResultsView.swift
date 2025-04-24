//
//  ResultsView.swift
//  FaceSDKAssignment
//
//  Created by Sebastian Presno on 23/04/25.
//

import SwiftUI

struct ResultsView: View {
  @Binding var face: FaceOO
  @Binding var showResults: Bool
  let targetPercentage: Double

  var body: some View {
    VStack(spacing: 32) {
      Text("Face Match between these images:")
        .font(.title)
        .fontWeight(.semibold)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .padding(.top, 40)

      HStack(spacing: 24) {
        Spacer()
        imageView(for: face.faceCaptureResponse?.image?.image)
        imageView(for: face.selectedImage)
        Spacer()
      }

      ResultsWheel(targetPercentage: targetPercentage)
        .padding()

      Button(action: {
        showResults = false
        face.faceCaptureResponse = nil
        face.selectedImage = nil
        face.isFaceCaptured = false
      }) {
        Text("Start Over")
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(12)
          .padding(.horizontal)
      }
      .padding(.bottom, 40)
    }
    .background(Color(.systemBackground))
    .edgesIgnoringSafeArea(.bottom)
  }

  @ViewBuilder
  private func imageView(for image: UIImage?) -> some View {
    if let img = image {
      Image(uiImage: img)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 150, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
    } else {
      VStack {
        Text("No image")
          .foregroundColor(.secondary)
          .frame(width: 150, height: 150)
          .background(Color.gray.opacity(0.1))
          .clipShape(RoundedRectangle(cornerRadius: 16))
      }
    }
  }
}


//#Preview {
//  ResultsView(showResults: .constant(true), targetPercentage: 99.7)
//}
