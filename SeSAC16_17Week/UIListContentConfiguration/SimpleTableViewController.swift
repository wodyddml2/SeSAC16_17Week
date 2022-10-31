//
//  SimpleTableViewController.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import UIKit

class SimpleTableViewController: UITableViewController {

    let list = ["슈비버거", "프랭크", "자갈치", "고래밥"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        content.text = list[indexPath.row] // textLabel
        content.secondaryText = "안녕하세용" //detailTextLabel
        
        cell.contentConfiguration = content //등록!

        return cell
    }
}
