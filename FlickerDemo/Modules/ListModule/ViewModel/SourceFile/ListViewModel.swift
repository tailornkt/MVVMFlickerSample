//
//  ListViewModel.swift
//  FlickerDemo
//
//  Created by Ravi Tailor on 02/07/18.
//  Copyright © 2018 Ravi Tailor. All rights reserved.
//

import Foundation

protocol ListViewModelViewDelegate : class
{
    func failToGetData(error : ApiError?)
    func getApiResponse(viewModel: Array<PhotoModel>?)
}

protocol ViewModelInterface : class {
    var viewDelegate : ListViewModelViewDelegate? {get set}
    var apiRequesManager : ListApiRequestManager? {get set}
    var title: String {get set}
    func itemAtIndex(_ index: Int) -> PhotoModel?
    func fetchData(_ searchText:String,pageNumber: Int)
}

class ListViewModel : ViewModelInterface {
    
    var title: String = "List"
    
    
    var viewDelegate: ListViewModelViewDelegate?
    
    var apiRequesManager: ListApiRequestManager?
    
    var feeds: [PhotoModel]? = [] {
        didSet {
            if let arr = feeds, arr.count > 0 {
                viewDelegate?.getApiResponse(viewModel: feeds)
            }
        }
    }
    func itemAtIndex(_ index: Int) -> PhotoModel? {
        return self.feeds?[index]
    }
    
    func fetchData(_ searchText: String, pageNumber: Int) {
        self.apiRequesManager?.fetchFlickerPhotos(pageNumber, searchText: searchText, onSuccess: { (array) in
            self.feeds?.append(contentsOf: array)
        }, onFail: { (error) in
            self.viewDelegate?.failToGetData(error: error as? ApiError)
        })
    }
}
