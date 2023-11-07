//
//  ViewController.swift
//  ListApp
//
//  Created by MustafaCakir on 7.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
    }
        
    @IBAction func didRemoveBarButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAlertWithCancel(title: "UYARI",
                                  message: "Listeyi tamamen temizlemek istiyor musun?",
                                  defaultButtonTitle: "Evet") { _ in
               self.data.removeAll()
               self.tableView.reloadData()
           }
       }

       func presentAlertWithCancel(title: String?, 
                                   message: String?,
                                   defaultButtonTitle: String,
                                   handler: ((UIAlertAction) -> Void)?) {
           let alertController = UIAlertController(title: title,
                                                   message: message,
                                                   preferredStyle: .alert)
           
           let defaultButton = UIAlertAction(title: defaultButtonTitle, 
                                             style: .default,
                                             handler: handler)
           
           let cancelButton = UIAlertAction(title: "Hayır", 
                                            style: .cancel) { _ in
           }
           
           alertController.addAction(defaultButton)
           alertController.addAction(cancelButton)
           
           present(alertController, animated: true)
    }
    
    @IBAction func didAddBarButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAddAlert()
    }
    
    func presentAddAlert() {
        let alertController = UIAlertController(title: "Yeni Eleman Ekle", 
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField()
        
        let defaultButton = UIAlertAction(title: "Ekle", 
                                          style: .default) { [weak self] _ in
            if let text = alertController.textFields?.first?.text, !text.isEmpty {
                self?.data.append(text)
                self?.tableView.reloadData()
            } else {
                self?.presentWarningAlert()
            }
        }
        
        let cancelButton = UIAlertAction(title: "Vazgeç", 
                                         style: .cancel)
        
        alertController.addAction(defaultButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }
    
    func presentWarningAlert() {
        presentAlert(title: "UYARI", 
                     message: "Liste elemanı boş olamaz",
                     defaultButtonTitle: "Tamam",
                     handler: nil)
    }
    
    func presentAlert(title: String?, 
                      message: String?,
                      defaultButtonTitle: String,
                      handler: ((UIAlertAction) -> Void)?) {
       
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                          style: .default,
                                          handler: handler)
                          alertController.addAction(defaultButton)
       
        present(alertController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Sil") { (_, _, completion) in
            self.data.remove(at: indexPath.row)
            self.tableView.reloadData()
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { (_, _, completion) in
            let alertController = UIAlertController(title: "Elemanı Düzenle", message: nil, preferredStyle: .alert)
            alertController.addTextField()
            
            let defaultButton = UIAlertAction(title: "Düzenle", style: .default) { [weak self] _ in
                if let text = alertController.textFields?.first?.text, !text.isEmpty {
                    self?.data[indexPath.row] = text
                    self?.tableView.reloadData()
                } else {
                    self?.presentWarningAlert()
                }
            }
            
            let cancelButton = UIAlertAction(title: "Vazgeç", style: .cancel)
            
            alertController.addAction(defaultButton)
            alertController.addAction(cancelButton)
            
            self.present(alertController, animated: true)
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return config
    }
}
