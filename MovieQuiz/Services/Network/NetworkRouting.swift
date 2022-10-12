//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Sergey on 08.10.2022.
//

import Foundation

protocol NetworkRouting {
    func get(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
