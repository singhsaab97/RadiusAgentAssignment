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
        case response(ResponseModel)
        case error(String)
    }
    
    private lazy var apiClient: MoyaProvider<FacilitiesAPIConstructor> = {
        return MoyaProvider<FacilitiesAPIConstructor>()
    }()
    
}

// MARK: - Exposed Helpers
extension FacilitiesDataHandler {
    
    func fetchData(completion: @escaping (State) -> Void) {
        completion(.loading)
        apiClient.request(.facilitiesList) { [weak self] result in
            switch result {
            case let .success(response):
                self?.decodeData(from: response, completion: completion)
            case let .failure(error):
                completion(.error(error.localizedDescription))
            }
        }
    }
    
}

// MARK: - Private Helpers
private extension FacilitiesDataHandler {
    
    func decodeData(from response: Response, completion: @escaping (State) -> Void) {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(ResponseModel.self, from: response.data)
            completion(.response(model))
        } catch {
            completion(.error(error.localizedDescription))
        }
    }
    
}
