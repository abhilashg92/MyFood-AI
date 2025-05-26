import SwiftUI
import UIKit

// MARK: - ImageCaptureView
/// Main view for capturing or selecting food images with cropping capability
struct ImageCaptureView: View {
    @StateObject private var viewModel = NutritionAnalysisViewModel()
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image Preview
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                        .padding()
                }
                
                // Camera and Gallery Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        sourceType = .camera
                        showImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.largeTitle)
                            Text("Camera")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "photo.fill")
                                .font(.largeTitle)
                            Text("Gallery")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                // Nutrition Info Display
                if viewModel.isAnalyzing {
                    ProgressView("Analyzing image...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let error = viewModel.error {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text(error.localizedDescription)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                    }
                    .padding()
                } else if let nutrition = viewModel.nutritionInfo {
                    NutritionInfoView(nutrition: nutrition)
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: sourceType)
        }
        .onChange(of: viewModel.selectedImage) { oldImage, newImage in
            if newImage != nil {
                // Automatically start analysis when image is selected
                Task {
                    await viewModel.analyzeImage()
                }
            }
        }
    }
}

// MARK: - NutritionInfoView
struct NutritionInfoView: View {
    let nutrition: NutritionInfo
    
    var body: some View {
        VStack(spacing: 16) {
            Text(nutrition.name)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                NutritionValueView(
                    title: "Calories",
                    value: String(format: "%.0f", nutrition.calories),
                    systemImage: "flame.fill",
                    color: .red
                )
                
                Divider()
                
                NutritionValueView(
                    title: "Fat",
                    value: String(format: "%.1fg", nutrition.fat_g),
                    systemImage: "drop.fill",
                    color: .yellow
                )
                
                Divider()
                
                NutritionValueView(
                    title: "Carbs",
                    value: String(format: "%.1fg", nutrition.carbs_g),
                    systemImage: "leaf.fill",
                    color: .green
                )
                
                Divider()
                
                NutritionValueView(
                    title: "Protein",
                    value: String(format: "%.1fg", nutrition.protein_g),
                    systemImage: "figure.walk",
                    color: .blue
                )
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            Text(nutrition.timestamp, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
        .padding()
    }
}

// MARK: - NutritionValueView
struct NutritionValueView: View {
    let title: String
    let value: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ImageCaptureView()
    }
} 