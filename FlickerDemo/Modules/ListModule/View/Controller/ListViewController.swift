//
//  ViewController.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    static let cellIdentifier = "ImageTableViewCellID"
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    var viewModel: ListViewModel? {
        willSet {
            viewModel?.viewDelegate = nil
        }
        didSet {
            viewModel?.viewDelegate = self
            refreshDisplay()
        }
    }
    
    var isLoaded: Bool = false
    var pageNumber: Int = 1
    var searchText: String = "xyz"
    
    func refreshDisplay()
    {
        if let viewModel = viewModel , isLoaded {
            title = viewModel.title
        } else {
            title = ""
        }
        self.tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.registerXib()
        self.setupSearchController()
        self.initializeAndLoadDefaultData()
    }
    func initializeAndLoadDefaultData() {
        self.isLoaded = true
        self.activityIndicator.startAnimating()
        let apiClient = ApiClient(sessionConfiguration: .default, queue: .main)
        let listApiManager = ListApiRequestManager(apiClient)
        self.viewModel = ListViewModel()
        self.viewModel?.apiRequesManager = listApiManager
        self.viewModel?.fetchData(self.searchText, pageNumber: pageNumber)
    }
    func registerXib() {
        self.tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: ListViewController.cellIdentifier)
    }
    func setupSearchController()  {
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Search your text"
        self.searchController.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        self.navigationItem.searchController = self.searchController
        
    }
}
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 0  {
            self.activityIndicator.startAnimating()
            self.viewModel?.feeds?.removeAll()
            self.refreshDisplay()
            self.pageNumber = 1
            self.searchText = text
            self.viewModel?.fetchData(self.searchText, pageNumber: pageNumber)
        }
    }
}
extension ListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            self.activityIndicator.startAnimating()
            self.viewModel?.feeds?.removeAll()
            self.refreshDisplay()
            self.pageNumber = 1
            self.searchText = text
            self.viewModel?.fetchData(self.searchText, pageNumber: pageNumber)
        }
        searchBar.text = nil
        self.searchController.isActive = false
    }
}

extension ListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = self.viewModel?.feeds {
            return arr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: ListViewController.cellIdentifier, for: indexPath)
        if let arr = self.viewModel?.feeds {
            let count = arr.count
            self.loadNextPageData(indexPath, isInProcess: self.isLoaded, count: count)
        }
        (tableCell as? ImageTableViewCell)?.setupData((self.viewModel?.itemAtIndex(indexPath.row)))
        tableCell.selectionStyle = .none
        return tableCell
    }
    
    func loadNextPageData(_ indexPath: IndexPath,isInProcess:Bool,count:Int)  {
        if indexPath.row >= (count - 5) && !isInProcess {
            self.isLoaded = true
            pageNumber += 1
            self.viewModel?.fetchData(self.searchText, pageNumber: pageNumber)
        }
    }
}

extension ListViewController : ListViewModelViewDelegate {
  
    func failToGetData(error: ApiError?) {
        var description = ""
        if let apiError = error {
            switch apiError {
            case .requestError(error: _, des: let des) :
                description = des
            case .parserError(code: _ , data: _, response: _ , error: _, des: let des):
                description = des
            default : description = "Api Error"
            }
        }
       
        self.isLoaded = false
        self.activityIndicator.stopAnimating()
    
        let alert = UIAlertController(title: "Alert", message: description, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getApiResponse(viewModel: Array<PhotoModel>?) {
        self.viewModel?.title = self.searchText
        self.refreshDisplay()
        self.isLoaded = false
        self.activityIndicator.stopAnimating()
       
    }
}

