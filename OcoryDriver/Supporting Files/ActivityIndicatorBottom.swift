//
//  ActivityIndicatorBottom.swift
//  OcoryDriver
//
//  Created by nile on 30/09/21.
//

import Foundation
import UIKit

extension UITableView {

func indicatorView() -> UIActivityIndicatorView{
    var activityIndicatorView = UIActivityIndicatorView()
    if self.tableFooterView == nil {
        let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
        activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        
        if #available(iOS 13.0, *) {
            activityIndicatorView.style = .large
        } else {
            // Fallback on earlier versions
            activityIndicatorView.style = .whiteLarge
        }
        
        activityIndicatorView.color = UIColor.gray
        activityIndicatorView.hidesWhenStopped = true

        self.tableFooterView = activityIndicatorView
        return activityIndicatorView
    }
    else {
        return activityIndicatorView
    }
}

func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
    indicatorView().startAnimating()
    if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
        if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                closure()
            }
        }
    }
}

func stopLoading() {
    if self.tableFooterView != nil {
        self.indicatorView().stopAnimating()
        self.tableFooterView = nil
    }
    else {
        self.tableFooterView = nil
    }
}
}
