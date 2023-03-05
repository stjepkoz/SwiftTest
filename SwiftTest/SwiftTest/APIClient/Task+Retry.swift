//
//  Task+Retry.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 26/02/23.
//

import Foundation

extension Task {
  static func retried(times: Int, backoff: TimeInterval = 1.0, priority: TaskPriority? = nil, operation: @escaping @Sendable () async throws -> Success) -> Task where Failure == Error {
    Task(priority: priority) {
      for attempt in 0..<times {
        do {
          return try await operation()
        }
        catch {
          let exponentialDelay = UInt64(backoff * pow(2.0, Double(attempt)) * 1_000_000_000)
          try await Task<Never, Never>.sleep(nanoseconds: exponentialDelay)
          continue
        }
      }
      return try await operation()
    }
  }
}
