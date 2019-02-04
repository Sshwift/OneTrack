import UIKit

class MainViewController: UITableViewController {

    private var steps = [Step]()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView(style: .gray)
        return ind
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getRequest()
        
        let addBtn: UIBarButtonItem = {
            let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
            btn.tintColor = UIColor(hex: "67dee0")
            return btn
        }()
        
        let targetBtn: UIBarButtonItem = {
            let btn = UIBarButtonItem(image: UIImage(named: "define_location"), style: .plain, target: self, action: #selector(targetBtnTapped))
            btn.tintColor = UIColor(hex: "67dee0")
            return btn
        }()
        
        title = "Steps"
        navigationItem.leftBarButtonItem = targetBtn
        navigationItem.rightBarButtonItem = addBtn
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "steps")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    @objc func targetBtnTapped() {
        let alert = UIAlertController(title: "Обновить цель", message: "Вы можете изменить количество шагов, которое вы хотите делать в день.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Готово", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            guard let target = textField.text else { return }
            UserDefaults.standard.set(Int(target), forKey: "target")
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "3000"
            textField.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func addBtnTapped() {
        print("addBtn Tapped")
    }
    
    private func getRequest() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let url = URL(string: "https://intern-f6251.firebaseio.com/intern/metric.json") else {
            self.showErrorConnection()
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                self.showErrorConnection()
                return
            }
            
            guard let data = data else {
                self.showErrorConnection()
                return
            }
            
            do {
                self.steps = try JSONDecoder().decode([Step].self, from: data)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.tableView.reloadData()
                }
            } catch {
                self.showErrorConnection()
            }
        }.resume()
    }
    
    private func showErrorConnection() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            let alert = UIAlertController(title: "Ошибка", message: "Проверьте соединение с интернетом.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Обновить", style: .default) { (_) in
                self.getRequest()
            }
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return steps.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "steps", for: indexPath) as! TableViewCell

        cell.step = steps[indexPath.section]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "eaeaea")
        return view
    }
    
}
