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
        TableViewData(name: "Placing Virtual Objects Plane", viewController: OverlayViewController()),
        TableViewData(name: "Appliyng Force Detection", viewController: AppliyingForceViewController()),
        TableViewData(name: "Launcing Missle", viewController: LaunchMissleViewController()),
        TableViewData(name: "Target Shooting", viewController: TargetShootingGameViewController()),
        TableViewData(name: "Measuring App", viewController: MeasuingAppViewController()),
        TableViewData(name: "Light", viewController: LightViewController()),
        TableViewData(name: "Arkit CoreMl", viewController: ArkitCoreMLViewController()),
        TableViewData(name: "Occlusion", viewController: OcclusionViewController()),
        TableViewData(name: "Portal", viewController: PortalViewController()),
        TableViewData(name: "Playing Video", viewController: VideoPlayerViewController()),
        TableViewData(name: "Image Detection", viewController: ImageDetectionViewController()),
        TableViewData(name: "Scaling Rotating", viewController: FurnitureAppViewController()),
        TableViewData(name: "Ar Kit Advertising", viewController: ARADSViewController()),
        TableViewData(name: "Downloading Model", viewController: DownloadingModelViewController()),
        TableViewData(name: "Persistance", viewController: PersistanceViewController()),
        TableViewData(name: "Reflections", viewController: ReflectionsViewController()),
        TableViewData(name: "Ar Watch", viewController: ArWatchViewController()),
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
