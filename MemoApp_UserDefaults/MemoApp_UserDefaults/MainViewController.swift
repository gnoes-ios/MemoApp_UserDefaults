//
//  ViewController.swift
//  MemoApp_UserDefaults
//
//  Created by 박주성 on 2/12/25.
//

import UIKit

class MainViewController: UIViewController {
    
    private var memoList: [String] {
        get { UserDefaults.standard.stringArray(forKey: "memoList") ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: "memoList") }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        self.title = "메모 앱"
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        setTableViewAutoLayout()
    }
    
    private func setTableViewAutoLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addMemo() {
        showMemoAlert(title: "새 메모", message: "메모 내용을 입력하세요.")
    }
    
    private func showMemoAlert(title: String, message: String, index: Int? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            if let index = index {
                textField.text = self.memoList[index]
            }
        }
        
        let saveAction = UIAlertAction(title: index == nil ? "추가" : "수정", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            if let index = index {
                self?.memoList[index] = text
            } else {
                self?.memoList.append(text)
            }
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = memoList[indexPath.row]
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showMemoAlert(title: "메모 수정", message: "메모 내용을 수정하세요.", index: indexPath.row)
    }
}
