import Foundation

// MARK: - NutritionInfo
struct NutritionInfo: Codable, Identifiable {
    let id: UUID
    let name: String
    let calories: Double
    let fat_g: Double
    let carbs_g: Double
    let protein_g: Double
    let timestamp: Date
    
    init(id: UUID = UUID(), 
         name: String, 
         calories: Double, 
         fat_g: Double, 
         carbs_g: Double, 
         protein_g: Double, 
         timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.calories = calories
        self.fat_g = fat_g
        self.carbs_g = carbs_g
        self.protein_g = protein_g
        self.timestamp = timestamp
    }
}

// MARK: - API Response
struct OpenAIVisionResponse: Codable {
    let name: String
    let calories: Double
    let fat_g: Double
    let carbs_g: Double
    let protein_g: Double
} 