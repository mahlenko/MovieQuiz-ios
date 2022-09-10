//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Sergey on 08.09.2022.
//

import Foundation

class NetworkClient {
    // MARK: - Public methods

    public func get(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
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
}
