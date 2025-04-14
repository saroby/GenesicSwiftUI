import SwiftUI

public struct UserCircleView: View {
    public enum Size {
        case xSmall
        case small
        case medium
        case large
        
        var value: CGFloat {
            switch self {
            case .xSmall: return 16
            case .small: return 32
            case .medium: return 48
            case .large: return 64
            }
        }
        
        var imagePadding: CGFloat {
            switch self {
            case .xSmall: return 3
            case .small: return 6
            case .medium: return 9
            case .large: return 12
            }
        }
    }
    
    let size: Size
    let imageURL: URL?
    let placeholder: UIImage
    
    public init(size: Size, imageURL: URL?, placeholder: UIImage = .init(systemName: "person.fill")!) {
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
                .scaledToFit()
                .padding(size.imagePadding)
                .frame(size: size.value)
                .symbolRenderingMode(.hierarchical)
                .background(Color.secondary)
        }
        .clipShape(.circle)
        .overlay {
            Circle()
                .strokeBorder(Color.secondary, lineWidth: 1)
        }
    }
}

#Preview {
    UserCircleView(size: .large, imageURL: URL(string: "https://picsum.photos/200"))
    UserCircleView(size: .medium, imageURL: URL(string: "https://picsum.photos/200"))
    UserCircleView(size: .small, imageURL: URL(string: "https://picsum.photos/200"))
    UserCircleView(size: .xSmall, imageURL: URL(string: "https://picsum.photos/200"))
}
