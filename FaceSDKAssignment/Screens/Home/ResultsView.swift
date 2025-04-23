//
//  ResultsView.swift
//  FaceSDKAssignment
//
//  Created by Sebastian Presno on 23/04/25.
//

import SwiftUI

struct ResultsView: View {
  let targetPercentage: Double
    var body: some View {
      ResultsWheel(targetPercentage: targetPercentage)
    }
}

#Preview {
  ResultsView(targetPercentage: 99.7)
}
