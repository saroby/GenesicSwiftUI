import UIKit
import PhotosUI
import SwiftUI

public struct ImagePicker: UIViewControllerRepresentable {
    var onImagePicked: (UIImage?) -> Void

    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지만 선택 가능
        configuration.selectionLimit = 1 // 한 번에 하나의 이미지 선택
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked)
    }

    public class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var onImagePicked: @MainActor (UIImage?) -> Void

        init(onImagePicked: @escaping @MainActor (UIImage?) -> Void) {
            self.onImagePicked = onImagePicked
        }

        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                onImagePicked(nil)
                return
            }
            provider.loadObject(ofClass: UIImage.self) { obj, _ in
                guard let image = obj as? UIImage else { return }
                
                Task {
                    await self.onImagePicked(image)
                }
            }
        }
    }
}

struct ImageURLPicker: UIViewControllerRepresentable {
    var onImagePicked: (URL?) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // 이미지만 선택 가능
        configuration.selectionLimit = 1 // 한 번에 하나의 이미지 선택
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var onImagePicked: @MainActor (URL?) -> Void

        init(onImagePicked: @escaping @MainActor (URL?) -> Void) {
            self.onImagePicked = onImagePicked
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                onImagePicked(nil)
                return
            }
            
            provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                guard let url else {
                    Task {
                        await self.onImagePicked(nil)
                    }
                    return
                }
                
                let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent("selectedImage.jpg")
                do {
                    try FileManager.default.copyItem(at: url, to: destinationURL)
                    print("Image saved at: \(destinationURL)")
                } catch {
                    print("Failed to copy file: \(error.localizedDescription)")
                }
                Task {
                    await self.onImagePicked(destinationURL)
                }
            }
        }
    }
}
