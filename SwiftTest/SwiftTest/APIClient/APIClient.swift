//
//  APIClient.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 26/02/23.
//

import Foundation
import Combine

enum APIError: Error {
    case urlError
    case requestError(error: NSError)
    case statusCodeError(statusCode: Int)
    case decodeError(error: NSError)
}

struct APIClient {
    
    func get<T: Decodable>(url: String, type: T.Type) async throws -> T {
        guard let urlFromString = URL(string: url) else {
            throw APIError.urlError
        }
        
        let data = try await handleRequest(urlRequest: URLRequest(url: urlFromString))
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw APIError.decodeError(error: error as NSError)
        }
        
    }
    
    func handleRequest(urlRequest: URLRequest) async throws -> Data {
        do {
            return try await Task.retried(times: 3) {
                print("API: fetching \(urlRequest.description)")
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw APIError.statusCodeError(statusCode: response.statusCode)
                }
                return data
            }.value
        } catch APIError.statusCodeError(statusCode: let statusCode) {
            throw APIError.statusCodeError(statusCode: statusCode)
        } catch {
            throw APIError.requestError(error: error as NSError)
        }
    }
    
    func getPublisher<T: Decodable>(url: String, type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: APIError.urlError)
                .eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .print("API: fetching \(url)")
            .mapError { APIError.requestError(error: $0 as NSError) }
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw APIError.statusCodeError(statusCode: response.statusCode)
                }
                return (data, response)
            }
            .retryWithBackoff(3)
            .map(\.data)
            .flatMap { data in
                Just(data)
                    .decode(type: type, decoder: JSONDecoder())
                    .mapError { APIError.decodeError(error: $0 as NSError) }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

