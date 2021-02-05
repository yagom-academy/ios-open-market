import UIKit

class ItemListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
}

extension ItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ItemListModel.shared.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell") as? ItemListTableViewCell {
            
            let model = ItemListModel.shared.data[indexPath.row]
            cell.setModel(index: indexPath.row ,ItemViewModel(model))
            
            return cell
        } else {
            return .init()
        }
    }
}
