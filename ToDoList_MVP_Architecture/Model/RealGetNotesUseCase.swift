//
//  RealGetNotesUseCase.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import Foundation

// MARK: - GetNotesUseCase протокол
// Протокол, определяющий методы, необходимые для извлечения заметок.
protocol GetNotesUseCase {
    // Метод, используемый для извлечения заметок
    func execute(completion: @escaping (Result<[Note], Error>) -> Void) // Функция выполнения, возвращающая результат в виде массива заметок или ошибки.
}

// MARK: - RealGetNotesUseCase
// Класс, который реализует GetNotesUseCase протокол.
class RealGetNotesUseCase: GetNotesUseCase {
    // Ссылка на репозиторий, который используется для извлечения заметок.
    private let repository: NoteRepositoryProtocol
    
    // Инициализатор класса
    init(repository: NoteRepositoryProtocol) { // Принимает репозиторий как параметр
        self.repository = repository
    }
    
    // MARK: - Метод execute
    // Реализация функции execute из протокола GetNotesUseCase
    func execute(completion: @escaping (Result<[Note], Error>) -> Void) {
        // Вызов функции getNotes из репозитория и передача completion handler
        repository.getNotes(completion: completion)
    }
}
