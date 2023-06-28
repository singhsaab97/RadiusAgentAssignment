//
//  FacilitiesDataHandler.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import Foundation
import Moya

final class FacilitiesDataHandler {
    
    /// Determines the state of response
    enum State {
        case loading
        case data(ResponseData)
        case error
    }
    
    private lazy var apiClient: MoyaProvider<FacilitiesAPIConstructor> = {
        return MoyaProvider<FacilitiesAPIConstructor>()
    }()
    
}

// MARK: - Exposed Helpers
extension FacilitiesDataHandler {
    
    func fetchData(completion: @escaping (State) -> Void) {
        apiClient.request(.facilitiesList) { [weak self] result in
            switch result {
            case let .success(response):
                self?.decodeData(from: response)
            case let .failure(error):
                print("Error \(error)")
            }
        }
    }
    
}

// MARK: - Private Helpers
private extension FacilitiesDataHandler {
    
    func decodeData(from response: Response) {
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(ResponseData.self, from: response.data)
            print("Model \(data)")
        } catch {
            print("Error deserializing JSON: \(error)")
        }
    }
    
}
