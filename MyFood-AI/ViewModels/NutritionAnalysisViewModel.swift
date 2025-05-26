import SwiftUI
import UIKit

// MARK: - NutritionAnalysisViewModel
@MainActor
class NutritionAnalysisViewModel: ObservableObject {
    private let openAIService: OpenAIService
    
    @Published var nutritionInfo: NutritionInfo?
    @Published var isAnalyzing = false
    @Published var error: OpenAIError?
    @Published var selectedImage: UIImage?
    
    init(openAIService: OpenAIService = .shared) {
        self.openAIService = openAIService
    }
    
    func analyzeImage() async {
        guard let image = selectedImage else { return }
        
        isAnalyzing = true
        error = nil
        
        do {
            nutritionInfo = try await openAIService.analyzeImage(image)
        } catch let error as OpenAIError {
            self.error = error
        } catch {
            self.error = .networkError(error)
        }
        
        isAnalyzing = false
    }
    
    func reset() {
        selectedImage = nil
        nutritionInfo = nil
        error = nil
        isAnalyzing = false
    }
} 