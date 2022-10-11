//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Sergey on 08.09.2022.
//

import Foundation

class NetworkClient: NetworkRouting {
    var activityIndicator: ActivityIndicatorProtocol?

    // MARK: - Public methods

    public func get(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        // Покажем индикатор загрузки
        if let activityIndicator {
            activityIndicator.show()
        }

        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            // Спрячем индикатор загрузки
            guard let self = self else { return }
            if let activityIndicator = self.activityIndicator {
                DispatchQueue.main.async {
                    activityIndicator.hide()
                }
            }

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
