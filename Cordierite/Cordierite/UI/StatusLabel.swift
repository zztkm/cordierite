import SwiftUI

struct StatusLabel: View {
  let state: AppState
  var recordingFeedback: RecordingFeedback?

  var body: some View {
    if let feedback = recordingFeedback, showsFeedbackIndicator {
      Label(feedback.title, systemImage: "exclamationmark.triangle.fill")
        .labelStyle(.titleAndIcon)
    } else {
      Label(state.menuBarTitle, systemImage: state.systemImageName)
        .labelStyle(.titleAndIcon)
    }
  }

  private var showsFeedbackIndicator: Bool {
    switch state {
    case .ready, .needsSetup:
      true
    case .loading, .starting, .recording, .processing:
      false
    }
  }
}

#Preview {
  StatusLabel(state: .ready, recordingFeedback: .silenceDiscarded)
}
