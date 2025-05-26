import Foundation
import UIKit

// MARK: - OpenAIError
enum OpenAIError: Error {
    case invalidAPIKey
    case networkError(Error)
    case invalidResponse
    case rateLimitExceeded
    case serverError
    
    var localizedDescription: String {
        switch self {
        case .invalidAPIKey:
            return "Invalid API key. Please check your OpenAI API key configuration."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server. Please try again."
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please try again later."
        case .serverError:
            return "Server error. Please try again later."
        }
    }
}

// MARK: - OpenAIService
class OpenAIService: ObservableObject {
    static let shared = OpenAIService()
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    @Published var isLoading = false
    @Published var error: OpenAIError?
    
    init(apiKey: String = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "") {
        self.apiKey = apiKey
    }
    
    // MARK: - Mock Data
    private let mockData: [NutritionInfo] = [
        NutritionInfo(name: "Pizza Slice", calories: 285, fat_g: 10.4, carbs_g: 35.7, protein_g: 12.2),
        NutritionInfo(name: "Caesar Salad", calories: 180, fat_g: 8.5, carbs_g: 12.3, protein_g: 15.6),
        NutritionInfo(name: "Hamburger", calories: 354, fat_g: 15.2, carbs_g: 33.8, protein_g: 20.4),
        NutritionInfo(name: "Sushi Roll", calories: 220, fat_g: 5.8, carbs_g: 38.2, protein_g: 8.9),
        NutritionInfo(name: "Chicken Breast", calories: 165, fat_g: 3.6, carbs_g: 0, protein_g: 31),
        NutritionInfo(name: "Pasta Bowl", calories: 320, fat_g: 2.5, carbs_g: 62.4, protein_g: 12.3),
        NutritionInfo(name: "Greek Yogurt", calories: 130, fat_g: 4.5, carbs_g: 8.2, protein_g: 15.8),
        NutritionInfo(name: "Fruit Smoothie", calories: 210, fat_g: 1.5, carbs_g: 45.6, protein_g: 5.2),
        NutritionInfo(name: "Steak", calories: 420, fat_g: 28.4, carbs_g: 0, protein_g: 42.6),
        NutritionInfo(name: "Fish Fillet", calories: 190, fat_g: 6.8, carbs_g: 0, protein_g: 32.4)
    ]
    
    // MARK: - Public Methods
    func analyzeImage(_ image: UIImage) async throws -> NutritionInfo {
        isLoading = true
        defer { isLoading = false }
        
        // For development, return mock data
        #if DEBUG
        return mockData.randomElement()!
        #else
        guard !apiKey.isEmpty else {
            throw OpenAIError.invalidAPIKey
        }
        
        do {
            let imageData = try await uploadImage(image)
            let response = try await callVisionAPI(with: imageData)
            return response
        } catch let error as OpenAIError {
            self.error = error
            throw error
        } catch {
            let openAIError = OpenAIError.networkError(error)
            self.error = openAIError
            throw openAIError
        }
        #endif
    }
    
    // MARK: - Private Methods
    private func uploadImage(_ image: UIImage) async throws -> Data {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw OpenAIError.invalidResponse
        }
        return imageData
    }
    
    private func callVisionAPI(with imageData: Data) async throws -> NutritionInfo {
        // TODO: Implement actual API call
        // For now, return mock data
        return mockData.randomElement()!
    }
} 