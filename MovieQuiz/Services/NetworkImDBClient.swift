//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Sergey on 08.09.2022.
//

import Foundation

class NetworkImDBClient {
    // MARK: - Properties

    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func get(method: RequestMethodProtocol, handler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: httpUrlRequest(method)) else {
            handler(.failure(NetworkError.invalidUrl))
            return
        }

        let urlRequest = URLRequest(url: url)

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error { handler(.failure(error)) }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                handler(.failure(NetworkError.invalideResponseCode))
            }

            guard let data = data else { return }
            handler(.success(data))
        }

        task.resume()
    }

    /// Вернет ссылку для запроса
    private func httpUrlRequest(_ method: RequestMethodProtocol) -> String {
        return "https://imdb-api.com/\(languageCode())/API/\(method.name())/\(apiKey)"
    }

    /// Вернет язык пользователья
    private func languageCode() -> String {
        if #available(iOS 16, *) {
            return Locale.current.language.languageCode?.identifier ?? "en"
        }

        return Locale.current.languageCode ?? "en"
    }
}
