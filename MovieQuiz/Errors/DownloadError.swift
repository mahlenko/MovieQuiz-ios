//
//  IMDBError.swift
//  MovieQuiz
//
//  Created by Sergey on 08.10.2022.
//

import Foundation

enum DownloadError: Error {
    case invalidUrl
    case imageException(String)
}

extension DownloadError: LocalizedError {
    public var imageException: String? {
        switch self {
        case .invalidUrl:
            return NSLocalizedString("URL недоступен.", comment: "")
        case let .imageException(message):
            return NSLocalizedString("Download image: \(message)", comment: "")
        }
    }
}
