//
//  ViewController.swift
//  ArKitProjects
//
//  Created by Eren  Çelik on 6.05.2021.
//

import UIKit
import SceneKit
import ARKit


class MainViewController: UIViewController {
    
    private var myTableView: UITableView!
    
    let data = [
        TableViewData(name: "Adding Multiple Box", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Overlay Plane", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Placaing Virtual Objects Plane", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Collision Detection", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Appliyng Force Detection", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Launcing Missle", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Target Shooting", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Measuring App", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Light", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Arkit CoreMl", viewController: ArkitCoreMLViewController()),
        TableViewData(name: "Occlusion", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Portal", viewController: PortalViewController()),
        TableViewData(name: "Playing Video", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Image Detection", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Scaling Rotating", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Ar Kit Advertising", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Downloading Model", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Image Tracking", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Persistance", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Reflections", viewController: AddingMultipleItemViewController()),
        TableViewData(name: "Ar Watch", viewController: AddingMultipleItemViewController()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = "Eren"
        myTableView = UITableView(frame: UIScreen.main.bounds)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
}
extension MainViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        cell.textLabel?.text = data[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = data[indexPath.row].viewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
struct TableViewData {
    let name : String
    let viewController : UIViewController
}
