import UIKit
import ObjectMapper

class GoogleImagesTableDelegate: BaseTableViewDelegate<Item>,ExplabdableTableDelegate{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableCell.reuseId) as! ImageTableCell
        cell.setup(getData(at: indexPath))
        setupExpandedCell(tableView: tableView, indexPath: indexPath, cell: cell)
        return cell
    }
    
    //MARK: ExplabdableTableDelegate
    var explandedIndexPath:IndexPath?
    weak var tableView:UITableView?
}



