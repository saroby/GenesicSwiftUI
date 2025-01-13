import SwiftUI

public struct UserCircleView: View {
    public enum Size {
        case small
        case medium
        case large
        
        var value: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 48
            case .large: return 64
            }
        }
    }
    
    let size: Size
    let imageURL: URL?
    let placeholder: UIImage
    
    public init(size: Size, imageURL: URL?, placeholder: UIImage = .init(systemName: "person")!) {
        self.size = size
        self.imageURL = imageURL
        self.placeholder = placeholder
    }
    
    public var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .frame(size: size.value)
        } placeholder: {
            Image(uiImage: placeholder)
                .resizable()
                .frame(size: size.value)
        }
        .background(Color.secondary)
        .clipShape(.circle)
    }
}

#Preview {
    UserCircleView(size: .large, imageURL: nil)
}
