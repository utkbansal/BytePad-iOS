//
//  DownloadsViewController.swift
//  BytePad-iOS
//
//  Created by Utkarsh Bansal on 13/11/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit

class DownloadsViewController: UIViewController {

    @IBOutlet weak var downloadsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.downloadsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

}

extension DownloadsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.downloadsTableView.dequeueReusableCell(withIdentifier: "downloads-cell")
        cell?.textLabel?.text = "Downloaded file"
        
        return cell!
        
    }
}
