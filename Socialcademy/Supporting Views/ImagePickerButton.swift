//
//  ImagePickerButton.swift
//  Socialcademy
//
//  Created by Joel Alejandro Milla Lopez on 08/01/24.
//

import SwiftUI
import PhotosUI

struct ImagePickerButton<Label: View>: View {
    @Binding var imageURL: URL?
    @ViewBuilder let label: () -> Label
    @State private var showImageSourceDialog = false
    @State private var sourceType: UIImagePickerController.SourceType?
    

    var body: some View {
        Group {
            Button {
                showImageSourceDialog = true
            } label: {
                label()
            }
        }
        .confirmationDialog("Choose Image", isPresented: $showImageSourceDialog) {
            Button("Choose from Library") {
                sourceType = .photoLibrary
            }
            Button("Take Photo") {
                sourceType = .camera
            }
            if imageURL != nil {
                Button("Remove Photo", role: .destructive) {
                    imageURL = nil
                }
            }
        }
        .fullScreenCover(item: $sourceType) { sourceType in
            ImagePickerView(sourceType: sourceType) {
                imageURL = $0
            }
            .ignoresSafeArea()
        }
    }
}

// Image Picker Controller to select photos using swiftUI libraries
private extension ImagePickerButton {
    struct ImagePickerView: UIViewControllerRepresentable {
        class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let view: ImagePickerView
            
            init(view: ImagePickerView) {
                self.view = view
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                guard let imageURL = info[.imageURL] as? URL else { return }
                view.onSelect(imageURL)
                view.dismiss()
            }
        }

        let sourceType: UIImagePickerController.SourceType
        let onSelect: (URL) -> Void
        
        @Environment(\.dismiss) var dismiss
        
        func makeCoordinator() -> ImagePickerCoordinator {
            return ImagePickerCoordinator(view: self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = context.coordinator
            imagePicker.sourceType = sourceType
            return imagePicker
        }
        
        func updateUIViewController(_ imagePicker: UIImagePickerController, context: Context) {}
    }
}

// For the full screen to work, it needs to conform to identifiable
extension UIImagePickerController.SourceType: Identifiable {
    public var id: String { "\(self)" }
}

//#Preview {
//    ImagePickerButton(imageURL: URL(string: ""), label: { Label("yes", systemImage: "pencil")})
//}
