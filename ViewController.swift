//
//  ViewController.swift
//  DisplayingImages
//
//  Created by Kiran Yechuri on 16/08/20.
//  Copyright © 2020 Kiran Yechuri. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView_Images: UITableView!
    var imagesArray = [NSDictionary]()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register TableView
        tableView_Images.register(UINib(nibName: "ImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "ImagesTableViewCell")
        tableView_Images.delegate = self
        tableView_Images.dataSource = self
        tableView_Images.reloadData()
        tableView_Images.tableFooterView = UIView()
        tableView_Images.addSubview(refreshControl)
        self.getData(url: "https://picsum.photos/v2/list?page=2&limit=20")
    }
    
    func getData(url:String){
        if Reachability.isConnectedToNetwork() == true {
            let loader = showLoader(view: self.view)
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { (response) in
                    self.refreshControl.endRefreshing()
                    loader.dismissLoader()
                    self.imagesArray.removeAll()
                    switch response.result{
                    case .success(let json):
                        let responseArray = json as! NSArray
                        for item in responseArray {
                            let responseDict = item as! NSDictionary
                            self.imagesArray.append(responseDict)
                        }
                        DispatchQueue.main.async {
                            self.tableView_Images.reloadData()
                            print("JSON Response :\(self.imagesArray)")
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }else{
            Helper.showNetworkAlert(vc: self, title: "Oops! We can't connect to the internet")
        }
    }
    
    func showLoader(view: UIView) -> UIActivityIndicatorView {
        //Declaration of spinner and customization
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height:60))
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        spinner.layer.cornerRadius = 3.0
        spinner.clipsToBounds = true
        spinner.hidesWhenStopped = true
        spinner.style = UIActivityIndicatorView.Style.white
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        return spinner
    }
    
    @objc func handleRefreshControl(_ refreshControl : UIRefreshControl){
        self.getData(url: "https://picsum.photos/v2/list?page=2&limit=20")
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView_Images.dequeueReusableCell(withIdentifier: "ImagesTableViewCell", for: indexPath) as! ImagesTableViewCell
        tableViewCell.selectionStyle = .none
        let data = self.imagesArray[indexPath.row]
        DispatchQueue.main.async {
            tableViewCell.displayImageView.sd_setImage(with: URL(string: data.value(forKey: "download_url") as! String), placeholderImage: UIImage(named: "placeholder.png"))
            tableViewCell.labelAuthorName.text = (data.value(forKey: "author") as! String)
        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.imagesArray[indexPath.row]
        Helper.showMessageAlert(vc: self, title: data.value(forKey: "author") as! String)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}


extension UIActivityIndicatorView {
    func dismissLoader() {
        self.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

