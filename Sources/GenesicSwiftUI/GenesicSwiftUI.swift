import SwiftUI

public extension View {
    public nonisolated func frame<Spacing: RawRepresentable>(
        width: Spacing? = nil,
        height: Spacing? = nil
    ) -> some View where Spacing.RawValue == CGFloat {
        self.frame(width: width?.rawValue, height: height?.rawValue)
    }

    public nonisolated func padding<Spacing: RawRepresentable>(
        _ edges: Edge.Set = .all,
        _ length: Spacing? = nil
    ) -> some View where Spacing.RawValue == CGFloat {
        self.padding(edges, length?.rawValue)
    }
}

public extension View {
    public nonisolated func size<Spacing: RawRepresentable>(
        _ value: Spacing
    ) -> some View where Spacing.RawValue == CGFloat {
        self.frame(width: value.rawValue, height: value.rawValue)
    }
    
    public nonisolated func size(
        _ value: CGFloat
    ) -> some View {
        self.frame(width: value, height: value)
    }
}

public extension HStack {
    public init<Spacing: RawRepresentable>(
        alignment: VerticalAlignment = .center,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) where Spacing.RawValue == CGFloat {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}

public extension VStack {
    public init<Spacing: RawRepresentable>(
        alignment: HorizontalAlignment = .center,
        spacing: Spacing,
        @ViewBuilder content: () -> Content
    ) where Spacing.RawValue == CGFloat {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}
