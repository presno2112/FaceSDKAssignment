//
//  ResultsWheel.swift
//  FaceSDKAssignment
//
//  Created by Sebastian Presno on 23/04/25.
//

import SwiftUI

struct ResultsWheel: View {
  @State private var percentage: CGFloat = 0.0
  
  var targetPercentage: CGFloat
    var body: some View {
      ZStack {
        Circle()
            .stroke(lineWidth: 30)
            .foregroundStyle(.gray)
        
        Circle()
          .trim(from: 0.0, to: percentage == 100.0 ? 1.0 : min(self.percentage, 95) / 100.0)
          .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
          .foregroundStyle(.blue)
          .rotationEffect(Angle(degrees: -90))
          .animation(.easeInOut(duration: 3), value: percentage)
        
        Text(String(format: "%.2f%%", min(self.percentage, 100.0)))
            .font(.system(size: 35, weight: .bold))
            .foregroundStyle(.blue)
    }
      .frame(width: 200, height: 200)
      .onAppear {
          withAnimation {
              self.percentage = targetPercentage
          }
      }
    }
}

#Preview {
  ResultsWheel(targetPercentage: 75)
}
