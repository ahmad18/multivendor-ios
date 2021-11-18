//
//  FavouritesTableViewController.swift
//  Multivendor
//
//  Created by Tintash on 14/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTable), name: Notification.Name("RefreshFavsTable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.buyNow), name: Notification.Name("BuyNowFavsCell"), object: nil)

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserManager.shared.favs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FavTableViewCell", for: indexPath) as! FavTableViewCell
        cell.product = UserManager.shared.favs[indexPath.row]
        cell.setupCell()
        return cell
    }
    
    @objc func reloadTable() {
        UIView.transition(with: self.tableView, duration: 0.5, options: .transitionCurlUp, animations: {self.tableView.reloadData()}, completion: nil)
    }
    
    @objc func buyNow() {
        performSegue(withIdentifier: "favsToCart", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
