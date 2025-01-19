import SwiftUI

public struct VerifiedView: View {
    public init() {
        
    }
    
    public var body: some View {
        Image(systemName: "checkmark.seal.fill")
            .foregroundColor(.blue) // 강조색 설정
            .background(Color.white) // 배경 설정
    }
}

#Preview {
    HStack {
        VerifiedView()
    }
}
