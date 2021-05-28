//
//  NotesListViewController.swift
//  Mooskine
//
//  Created by Fabiana Petrovick on 19/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController, UITableViewDataSource {
    /// A table view that displays a list of notes for a notebook
    @IBOutlet weak var tableView: UITableView!
    
    /// The notebook whose notes are being displayed
    var notebook: Notebook!
    
    var notes:[Note] = []
    
    var dataController:DataController! //injetar o DataController
    
    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = notebook.name
        navigationItem.rightBarButtonItem = editButtonItem
        //pegar somente as notes do notebook selecionado
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "notebook == %@", notebook) //O "%@" sera substituido pelo notebook atual
        fetchRequest.predicate = predicate //o usa o predicado
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false) //organiza por data de criacao ascendente
        fetchRequest.sortDescriptors = [sortDescriptor] // array
        // pedimos aos contatos de ManagedObject para realizar a busca
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            // se der certo armazenamos as notacoes no array de anotacoes da classe
            notes = result
      //      tableView.reloadData()
        }

        updateEditButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Actions
    
    @IBAction func addTapped(sender: Any) {
        addNote()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Editing
    
    // Adds a new `Note` to the end of the `notebook`'s `notes` array
    func addNote() {
        
        let note = Note(context: dataController.viewContext) //criaremos uma anotacao registrada a um contexto
        note.text = "New note" //configuramos o texto como um "New note"
        note.creationDate = Date() // data de criacao
        note.notebook = notebook // configura o notebook
        try? dataController.viewContext.save() //salvar no contexto
        notes.insert(note, at: 0) //adicionamos a frente do array de anotacoes desta classe
        //tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade) //aparece no final da tabela
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade) //aparece no topo da tabela
        updateEditButtonState()
    }
    
    // Deletes the `Note` at the specified index path
    func deleteNote(at indexPath: IndexPath) {
        //persisntecia = ao reiniciar o item permanece deletado
        let noteToDelete = note(at: indexPath) // referencia da anotacao a ser deletada
        dataController.viewContext.delete(noteToDelete) //deleta do contexto
        try? dataController.viewContext.save() //salva a alteracao
        notes.remove(at: indexPath.row) //remove do array de anotacoes
        tableView.deleteRows(at: [indexPath], with: .fade)
        if numberOfNotes == 0 {
            setEditing(false, animated: true)
        }
        updateEditButtonState()
    }
    
    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = numberOfNotes > 0
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfNotes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNote = note(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.defaultReuseIdentifier, for: indexPath) as! NoteCell
        
        // Configure cell
        cell.textPreviewLabel.text = aNote.text
        if let creationDate = aNote.creationDate {
            cell.dateLabel.text = dateFormatter.string(from: creationDate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNote(at: indexPath)
        default: () // Unsupported
        }
    }
    
    // Helpers
    
    var numberOfNotes: Int { return notes.count }
    
    func note(at indexPath: IndexPath) -> Note {
        return notes[indexPath.row]
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NoteDetailsViewController, we'll configure its `Note`
        // and its delete action
        if let vc = segue.destination as? NoteDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.note = note(at: indexPath)
                
                vc.onDelete = { [weak self] in
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        self?.deleteNote(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
