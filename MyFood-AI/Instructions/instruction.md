Project: MyFoodAI
Platform: iOS
Language: Swift
Frameworks: SwiftUI, Core ML, Vision, Realm (or Core Data), OpenAI API


Purpose
MyFoodAI allows users to capture food images, detect if the content is food, retrieve nutrition information using AI, and store logs securely for offline history access.


Modules to Implement
1. Image Capture & Picker
Use UIImagePickerController or PHPickerViewController with SwiftUI.

Support camera and gallery selection.

2. Food Detection with Core ML
Integrate VNCoreMLModel with Core ML model (e.g., Food101).

Detect food name.

Show "No food item found" if nothing is detected.

3. AI-Powered Nutrition Info (OpenAI)
Call OpenAI GPT API with detected food name.

Expected keys:

name, calories, fat_g, carbs_g, protein_g

Handle:

Internet failure

API rate limits

Invalid responses

4. Result Display
Display:

Image

Food name

Calories

Fat, Carbs, Protein

Timestamp

5. History Logging (Secure & Offline)
Choose either: Realm, Core Data

6. API Key Management (Secure)
🔒 Do NOT hardcode keys or commit them to Git

