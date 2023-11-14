//
//  ImagePickerButton.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/13/23.
//

import SwiftUI

struct ImagePickerButton<Label: View>: View {
    @Binding var imageURL: URL?
    @ViewBuilder let label: () -> Label
    
    @State private var showImageSourceDialog = false
    @State private var sourceType: UIImagePickerController.SourceType?
    
    var body: some View {
        Button(action: {
            showImageSourceDialog = true
        }) {
            label()
        }
        .confirmationDialog("Choose Image", isPresented: $showImageSourceDialog) {
            Button("Choose from Library", action: {
                sourceType = .photoLibrary
            })
            Button("Take Photo", action: {
                sourceType = .camera
            })
            if imageURL != nil {
                Button("Remove Photo", role: .destructive, action: {
                    imageURL = nil
                })
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

private extension ImagePickerButton {
    struct ImagePickerView: UIViewControllerRepresentable {
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

private extension ImagePickerButton {
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let view: ImagePickerView
        var selectedImage: UIImage!
        var imageURL: URL!
        
        init(view: ImagePickerView) {
            self.view = view
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // Solution: https://stackoverflow.com/questions/64045380/swiftui-image-picker-url-image-from-camera
            // https://discuss.codecademy.com/t/socialcademy-unable-to-click-use-photo/672920/4
            
            if let image = info[.editedImage] as? UIImage {
                selectedImage = image
            } else if let image = info[.originalImage] as? UIImage {
                selectedImage = image
            }
            
            if picker.sourceType == .camera {
                let imgName = "\(UUID().uuidString).jpeg"
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                
                let data = selectedImage.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                imageURL = URL.init(fileURLWithPath: localPath)
                
            } else if let selectedImageURL = info[.imageURL] as? URL {
                imageURL = selectedImageURL
            } else {
                return
            }
            
            // this doesn't take into account the camera doesn't have a imageURL
            //            guard let imageURL = info[.imageURL] as? URL else { return }
            view.onSelect(imageURL)
            view.dismiss()
        }
    }
}

extension UIImagePickerController.SourceType: Identifiable {
    public var id: String { "\(self)" }
}

#Preview {
    ImagePickerButton(imageURL: .constant(nil)) {
        Label("Choose Image", systemImage: "photo.fill")
    }
}
