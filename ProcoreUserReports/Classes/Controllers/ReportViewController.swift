//
//  ReportViewController.swift
//  ProcoreUserReports
//
//  Created by Kevin McKee on 8/16/18.
//  Copyright © 2018 Procore. All rights reserved.
//

import UIKit

class ReportViewController: UITableViewController {

    var reports = [UserReport]()
    private let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startListener()
    }

    private func startListener() {
        Database.listen { (report: UserReport?, changeType, error) in

            guard let report = report, let changeType = changeType else {
                return
            }
            
            switch changeType {
            case .added:
                self.reports.append(report)
                break
            case .modified:
                let index = self.reports.index(where: { (other) -> Bool in
                    return other.documentID == report.documentID
                })
                
                if let index = index {
                    self.reports[index] = report
                }
                break
            case .removed:
                // Super lazy matching going on ...
                self.reports = self.reports.filter { $0.documentID != report.documentID }
                break
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sendReport() {
        Database.sendSampleReport()
    }
}

extension ReportViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let report = reports[indexPath.row]
        cell.textLabel?.text = report.login
        cell.detailTextLabel?.text = "\(report.userID ?? 0)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

