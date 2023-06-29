# RadiusAgentAssignment
iOS assignment for an opportunity at RadiusAgent

# MVVM
My choice of architecture for this assignment was MVVM (Model-View-ViewModel) because it allows me to use protocol-oriented programming and I feel more in sync with the actual essence of Swift. MVVM offers a structured and organized approach to iOS development, improving testability, maintainability, reusability, scalability, and user experience. It offers the following advantages:

1. Separation of modules: Clear division of code into Model, View, and ViewModel for better maintainability.
2. Scalability: Ability to add or modify features without impacting other parts of the codebase.
3. Reusability: ViewModel encapsulates presentation logic, allowing for reuse across multiple views.
4. Testability: Easy unit testing by isolating presentation logic in the ViewModel.
5. Reactive Programming: Integration with reactive programming frameworks simplifies handling of asynchronous operations and UI bindings.
6. Enhanced User Experience: Real-time updates and responsiveness through data bindings.

# Moya
Moya is a very popular networking library for Swift. I feel more comfortable using Moya not only because I've had a great amount of experience with it in the past but also the fact that it provides several advantages over primitive networking approaches such as:

1. Abstraction of Network Layer: Simplifies network requests and responses.
2. Type-Safety: Ensures compile-time validation and reduces runtime errors.
3. API Layer Organization: Easy management of API endpoints and services.
4. Readability and Maintainability: Code becomes clear and easy to understand.
5. Integration with Reactive Programming: Seamlessly integrates with RxSwift and Combine.
6. Testability: Easier unit testing with mockable network requests.

# SnapKit
SnapKit is another very popular Swift library for auto layout. I've used a mix of programmatic and storyboard UI in the assignment and switched between both wherever felt necessary. SnapKit offers the following advantages:

1. Simplified Syntax: Clean and expressive API for creating constraints.
2. Type-Safety: Ensures compile-time validation and reduces runtime errors.
3. Less Boilerplate: Achieve complex layouts with fewer lines of code.
4. Adaptability: Easily handle dynamic layouts for different screen sizes and orientations.
5. UIKit and AppKit Integration: Compatible with iOS, macOS, and tvOS development.
