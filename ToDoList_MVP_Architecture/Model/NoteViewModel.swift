//
//  NoteViewModel.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import Foundation

// MARK: - NoteViewModel
// Структура, представляющая модель представления заметки.
struct NoteViewModel: Identifiable {
    // Уникальный идентификатор заметки
    let id: UUID
    // Заголовок заметки
    let title: String
    // Статус завершения заметки
    let isComplete: Bool
    // Дата
    let dueDate: Date
    // Подробная заметка
    let notes: String?
    
    // MARK: - Инициализатор
    // Создаем новый экземпляр модели представления заметки на основе предоставленной заметки.
    init(from note: Note) {
        self.id = note.id
        self.title = note.title
        self.isComplete = note.isComplete
        self.dueDate = note.dueDate
        self.notes = note.notes
    }
}
