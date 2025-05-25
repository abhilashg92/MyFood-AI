import SwiftUI
import UIKit

// MARK: - ImageCaptureView
/// Main view for capturing or selecting food images
struct ImageCaptureView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    // MARK: - View Body
    var body: some View {
        VStack(spacing: 20) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 40) {
                Button(action: { presentCamera() }) {
                    VStack {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 30))
                        Text("Camera")
                            .font(.headline)
                    }
                }
                .foregroundColor(.blue)
                
                Button(action: { presentPhotoLibrary() }) {
                    VStack {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 30))
                        Text("Gallery")
                            .font(.headline)
                    }
                }
                .foregroundColor(.blue)
            }
        }
        .padding()
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
        }
    }
    
    // MARK: - Private Methods
    private func presentCamera() {
        sourceType = .camera
        isImagePickerPresented = true
    }
    
    private func presentPhotoLibrary() {
        sourceType = .photoLibrary
        isImagePickerPresented = true
    }
}

// MARK: - Preview Provider
struct ImageCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCaptureView()
    }
} 