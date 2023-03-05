//
//  Publisher+Retry.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 26/02/23.
//

import Foundation
import Combine

extension Publisher {
    
    func retryWithBackoff<T, E>(_ retries: Int,
                                backoff: TimeInterval = 1.0,
                                condition: ((E) -> Bool)? = nil)
    -> Publishers.TryCatch<Self, AnyPublisher<T, E>>
    where T == Self.Output, E == Self.Failure
    {
        return self.tryCatch { error -> AnyPublisher<T, E> in
            if condition?(error) ?? true {
                var attempt = 0
                return Just(Void())
                    .flatMap { _ -> AnyPublisher<T, E> in
                        let delay = Int(backoff * pow(2.0, Double(attempt)))
                        let result = Just(Void())
                            .delay(for: .init(integerLiteral: delay), scheduler: DispatchQueue.global())
                            .flatMap { _ in
                                return self
                            }
                        attempt = attempt + 1
                        return result.eraseToAnyPublisher()
                    }
                    .retry(retries - 1)
                    .eraseToAnyPublisher()
            }
            else {
                throw error
            }
        }
    }
}
