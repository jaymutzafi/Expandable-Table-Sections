//
//  TableViewController.swift
//  ExpandableSections
//
//  Created by Jay Mutzafi on 9/3/17.
//  Copyright © 2017 Paradox Apps. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // Data structure for a section. This can/should go in a separate file
    struct TableItem {
        var section: String
        var items: [String]
        var expanded: Bool
    }
    
    // Create array of data sections
    var list = [TableItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding placeholder data of 3 sections
        let section1 = TableItem(section: "First", items: ["item1","item2","item3"], expanded: true)
        let section2 = TableItem(section: "Second", items: ["item1","item2","item3"], expanded: true)
        let section3 = TableItem(section: "Third", items: ["item1","item2","item3"], expanded: true)
        
        list.append(section1)
        list.append(section2)
        list.append(section3)
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return number of section in table from data
        return list.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of rows in each section from data
        return list[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell with the identifier which was set in the storyboard prototype cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // set cell data/name from our data object
        cell.textLabel?.text = list[indexPath.section].items[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // set the data/name of a section header
        return list[section].section
    }
    
    
    // customize table headers
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // create a header of type of our subclassed header with section number
        let headerView = ExpandableHeader()
        
        // assign selected/current section number to the header object
        headerView.section = section
        
        // create Gesture Recognizer to add ability to select header to this cutsom header with an action
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerClicked(sender:)))
        
        // add Gesture Recognizer to our header
        headerView.addGestureRecognizer(tapGesture)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // check if row's section expanded parameter is set to true or false. set height of rows accordingly to hide or show them
        if list[indexPath.section].expanded == true {
            return 44
        } else {
            return 0
        }
    }
    
    // function that is called on section header tap
    func headerClicked(sender: UITapGestureRecognizer) {
        
        // sender is the tap guestre, which has the element that was tapped, i.e. our header view. Assign it to a parameter and cast it of type of our subclassed header
        let header = sender.view as! ExpandableHeader
        
        // toggle the ture or false condition of this section
        if list[header.section].expanded == true {
            list[header.section].expanded = false
        } else {
            list[header.section].expanded = true
        }
        
        // loop through the rows of this section and reload them with animation
        tableView.beginUpdates()
        for i in 0 ..< list[header.section].items.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: header.section)], with: .automatic)
        }
        tableView.endUpdates()
    }

}

// sub class the section header class to add a section number so we can pass it with the tap guestre
class ExpandableHeader: UITableViewHeaderFooterView {
    var section: Int = 0
}

