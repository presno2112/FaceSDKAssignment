//
//  ActionButton.swift
//  FaceSDKAssignment
//
//  Created by Sebastian Presno on 23/04/25.
//

import SwiftUI

struct ActionButton: View {
  let text: String
  let isPhoto : Bool
  var isActionDone : Bool
    var body: some View {
      ZStack{
        RoundedRectangle(cornerRadius: 20)
          .frame(width: 180, height: 220)
          .foregroundStyle(Color.white)
          .shadow(radius: 2)
        VStack{
          if isActionDone{
            Image(systemName: "checkmark.circle.fill")
              .font(.system(size: 40, weight: .bold, design: .default))
              .foregroundStyle(Color.green)
            Text("Photo Saved")
              .foregroundStyle(Color.green)
              .padding()
          } else {
            Image(systemName: isPhoto ? "photo" : "camera.shutter.button")
              .font(.system(size: 40, weight: .bold, design: .default))
            Text(text)
              .padding()
          }
        }
      }
    }
}

#Preview {
  ActionButton(text: "Photo", isPhoto: true, isActionDone: (false))
}
