//
//  IMDBError.swift
//  MovieQuiz
//
//  Created by Sergey on 08.10.2022.
//

import Foundation

enum IMDBError: Error {
    case invalidRequstException(String)
}

extension IMDBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidRequstException(message):
            return NSLocalizedString("IMDB API Error: \(message)", comment: "")
        }
    }
}
