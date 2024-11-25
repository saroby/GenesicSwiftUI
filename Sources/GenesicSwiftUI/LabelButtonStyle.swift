import SwiftUI

// default pressed effect를 제거하기 위함
public struct LabelButtonStyle: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
    }
}


#Preview {
    Button {
        
    } label: {
        Text("Dummy")
    }
    .buttonStyle(LabelButtonStyle())

}
