import SwiftUI

// MARK: - ImageEditorView
/// A custom view for cropping images
struct ImageEditorView: View {
    let image: UIImage
    @Binding var editedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    // MARK: - View Body
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.black.opacity(0.8)
                    
                    // Crop overlay
                    Rectangle()
                        .fill(Color.clear)
                        .border(Color.white, width: 1)
                        .frame(width: min(geometry.size.width * 0.9, geometry.size.height * 0.9),
                               height: min(geometry.size.width * 0.9, geometry.size.height * 0.9))
                    
                    // Image with gestures
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let delta = value / lastScale
                                    scale = min(max(scale * delta, 0.5), 3.0)
                                    lastScale = value
                                }
                                .onEnded { _ in
                                    lastScale = 1.0
                                }
                        )
                        .simultaneousGesture(
                            DragGesture()
                                .onChanged { value in
                                    let delta = CGSize(
                                        width: value.translation.width + lastOffset.width,
                                        height: value.translation.height + lastOffset.height
                                    )
                                    offset = constrainOffset(delta, in: geometry.size)
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                }
            }
            .navigationTitle("Crop Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        cropImage()
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Constrains the offset to keep the image within bounds
    private func constrainOffset(_ offset: CGSize, in size: CGSize) -> CGSize {
        let maxOffset = (scale - 1) * size.width / 2
        return CGSize(
            width: min(max(offset.width, -maxOffset), maxOffset),
            height: min(max(offset.height, -maxOffset), maxOffset)
        )
    }
    
    /// Crops the image based on current scale and offset
    private func cropImage() {
        let cropZone = CGRect(
            x: -offset.width / scale,
            y: -offset.height / scale,
            width: image.size.width / scale,
            height: image.size.height / scale
        )
        
        if let cgImage = image.cgImage?.cropping(to: cropZone) {
            self.editedImage = UIImage(cgImage: cgImage)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview Provider
struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditorView(
            image: UIImage(systemName: "photo") ?? UIImage(),
            editedImage: .constant(nil)
        )
    }
} 