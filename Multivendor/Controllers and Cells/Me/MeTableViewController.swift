//
//  MeTableViewController.swift
//  Multivendor
//
//  Created by Tintash on 11/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import Material

class MeTableViewController: UITableViewController {

    fileprivate var menuButton: IconButton!
    fileprivate var searchButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeHeadingTableViewCell", for: indexPath) as! MeHeadingTableViewCell
            cell.headingName.text = "ORDERS HISTORY"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeRowTableViewCell", for: indexPath) as! MeRowTableViewCell
            cell.rowName.text = "My Orders"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeHeadingTableViewCell", for: indexPath) as! MeHeadingTableViewCell
            cell.headingName.text = "ACCOUNT"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeRowTableViewCell", for: indexPath) as! MeRowTableViewCell
            cell.rowName.text = "View/Edit Profile"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeRowTableViewCell", for: indexPath) as! MeRowTableViewCell
            cell.rowName.text = UserManager.shared.isLoggedIn ? "Logout" : "Login/Register"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            if let cell = tableView.cellForRow(at: indexPath) as? MeRowTableViewCell {
                if (cell.rowName.text == "Logout") {
                    UserManager.shared.isLoggedIn = false
                    showAlertInViewController(self, titleStr: "Logged Out", messageStr: "You have logged out from Multivendor", okButtonTitle: "Okay", cancelButtonTitle: nil)
                    tableView.reloadData()
                }
                else {
                    performSegue(withIdentifier: "MeToLogin", sender: nil)
                }
            }
        default:
            return
        }
    }

}

extension MeTableViewController {
    
    func setupNavBar() {
        
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.addTarget(self, action: #selector(menuBarButtonPressed), for: .touchUpInside)
        
        searchButton = IconButton(image: Icon.cm.search)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        navigationItem.titleLabel.text = "Multivendor"
        navigationItem.detailLabel.text = "Online Store"
        navigationItem.leftViews = [menuButton]
        navigationItem.rightViews = [searchButton]
    }
    
    @objc func searchButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchManagerViewController") as! SearchManagerViewController
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func menuBarButtonPressed() {
        evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
}

