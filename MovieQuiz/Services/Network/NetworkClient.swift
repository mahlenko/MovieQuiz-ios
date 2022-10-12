//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Sergey on 08.09.2022.
//

import Foundation

class NetworkClient: NetworkRouting {
    // MARK: - Public methods

    public func get(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // Проверим, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
            }

            // Проверим, пришел ли успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                handler(.failure(NetworkError.invalideResponseCode))
            }

            // Вернем даныне
            guard let data = data else { return }
            handler(.success(data))
        }
        .resume()
    }
}
