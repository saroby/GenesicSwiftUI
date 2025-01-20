import Foundation

public extension Int {
    static func random() -> Int {
        return .random(in: 0...1000000)
    }
}

public extension String {
    enum StringRandom {
        case sentence
        case userID
        case userName
        case id
    }
    
    private static func sentence() -> String {
        return "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    }
    
    private static func userID() -> String {
        return Self.id()
    }
    
    private static func userName() -> String {
        return "Louis"
    }
    
    private static func id() -> String {
        return UUID().uuidString
    }
    
    static func random(_ random: StringRandom) -> String {
        switch random {
        case .sentence: return sentence()
        case .userID:   return userID()
        case .userName: return userName()
        case .id:       return id()
        }
    }
}

public extension Date {
    static func random() -> Date {
        return .now.advanced(by: -Double.random(in: 0..<10000))
    }
}

public extension URL {
    enum URLRandom {
        case userImage
        case audio
        case video
        case size(width: Int, height: Int)
    }
    
    static func random(_ random: URLRandom) -> URL {
        switch random {
        case .userImage:
            return URL(string: "https://picsum.photos/200")!
        case .audio:
            return URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")!
        case .video:
            return URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        case let .size(width, height):
            return URL(string: "https://picsum.photos/\(width)/\(height)")!
        }
    }
}
