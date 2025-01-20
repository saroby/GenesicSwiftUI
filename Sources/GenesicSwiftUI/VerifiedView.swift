import SwiftUI

public struct VerifiedView: View {
    public init() {
        
    }
    
    public var body: some View {
        Image(systemName: "checkmark.seal.fill")
            .foregroundStyle(.white, .blue)
    }
}

#Preview {
    HStack {
        VerifiedView()
    }
}
