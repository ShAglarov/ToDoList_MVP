//
//  RealServiceImplementation.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import Foundation

// MARK: - ServiceProtocol Протокол
// Протокол, определяющий обязательные методы для работы с заметками.
protocol ServiceProtocol {
    // Метод для получения заметок.
    func getNotes(completion: @escaping (Result<[Note], Error>) -> Void) // Функция выполнения, принимающая результат запроса в виде массива заметок или ошибки.

    // Метод для сохранения заметок.
    func saveData(notes: [Note], completion: @escaping (Result<Void, Error>) -> Void) // Функция выполнения, принимающая массив заметок и возвращающая результат сохранения или ошибку.
}

// MARK: - RealServiceImplementation
// Класс, реализующий ServiceProtocol протокол.
class RealServiceImplementation: ServiceProtocol {

    // MARK: - Метод getNotes
    // Реализация функции getNotes из протокола ServiceProtocol
    func getNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        // Здесь при необходимости будем делать запрос на получение заметок от сервера.
        completion(.success([])) // пока вернем пустой массив
    }
    
    // MARK: - Метод saveData
    // Реализация функции saveData из протокола ServiceProtocol
    func saveData(notes: [Note], completion: @escaping (Result<Void, Error>) -> Void) {
        // Здесь при необходимости будем делать запрос на сохранение заметок на сервер.
        completion(.success(())) /// Пока просто вернем success
    }
}
