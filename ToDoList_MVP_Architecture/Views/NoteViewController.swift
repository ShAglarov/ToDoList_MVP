//
//  NoteViewController.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import UIKit
import SnapKit

// MARK: - NoteViewProtocol
// Протокол для отображения заметок и ошибок.
protocol NoteViewProtocol: AnyObject {
    func displayNotes(with notes: [NoteViewModel]) // Функция для отображения заметок.
    func showError(message: String) // Функция для отображения ошибки.
}

// MARK: - NoteViewController
// ViewController для отображения и добавления заметок.
class NoteViewController: UIViewController, NoteViewProtocol {
    
    // Сервис для работы с файлами.
    private let fileHandler: FileHandlerProtocol = FileHandler()
    
    // Презентер заметок.
    var presenter: NotePresenterProtocol!
    
    // Массив заметок.
    var notes: [NoteViewModel] = []
    
    // MARK: - UI elements
    // Таблица для отображения заметок.
    var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настраиваем внешний вид и расположение элементов на экране.
        setupConfigureConstraints()
        
        // Создаем кнопку добавления новой заметки.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        // Настраиваем источник данных и делегат для таблицы.
        tableView.dataSource = self
        tableView.delegate = self
        
        // Настраиваем сервис и кэш для работы с заметками.
        let service: ServiceProtocol = RealServiceImplementation()
        let cache: CacheProtocol = CoreDataCache(persistentContainer: (UIApplication.shared.delegate as! AppDelegate).persistentContainer)
        
        // Создаем репозиторий и use case для работы с заметками.
        let noteRepository = NoteRepository(service: service, cache: cache)
        let getNotesUseCase = RealGetNotesUseCase(repository: noteRepository)
        let saveNotesUseCase = RealSaveNotesUseCase(repository: noteRepository)
        
        // Создаем презентер для заметок.
        presenter = NotePresenter(view: self, getNotes: getNotesUseCase, saveNotes: saveNotesUseCase)
        
        // Уведомляем презентер о загрузке экрана.
        presenter.viewDidLoad()
    }
    
    // MARK: - Methods
    // Метод добавления новой заметки.
    @objc private func addButtonTapped() {
        let newNote = Note(id: UUID(), title: "New Note", isComplete: false, dueDate: Date(), notes: "note")
        let newNoteViewModel = NoteViewModel(from: newNote)
        addNewNote(note: newNoteViewModel)
    }
    
    // Функция для отображения заметок.
    func displayNotes(with notes: [NoteViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.notes = notes
            self?.tableView.reloadData()
            
            UIView.transition(with: self?.tableView ?? UIView(),
                              duration: 1.35,
                              options: .transitionCrossDissolve,
                              animations: { self?.tableView.reloadData() })
        }
    }
    
    // Функция для отображения ошибки.
    func showError(message: String) {
        // ...
    }
    
    // Функция для добавления новой заметки.
    func addNewNote(note: NoteViewModel) {
        notes.append(note)
        saveNotes()
        tableView.reloadData()
    }
    
    // Функция для сохранения заметок.
    private func saveNotes() {
        presenter.saveNotes(notes: notes)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NoteViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Возвращает количество строк в таблице.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // Настраивает ячейку таблицы.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.notes
        return cell
    }
}

// MARK: - View setup
extension NoteViewController {
    
    // Функция для настройки внешнего вида и расположения элементов на экране.
    func setupConfigureConstraints() {
        navigationItem.title = "Напоминания"
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
