//
//  ToDoService.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 04.08.2025.
//

import Foundation

protocol TodoServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void)
}

final class TodoService: TodoServiceProtocol {
    let toDoUrlString: String = "https://dummyjson.com/todos"
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        guard let url = URL(string: toDoUrlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TodoResponse.self, from: data)
                completion(.success(response.todos))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}
