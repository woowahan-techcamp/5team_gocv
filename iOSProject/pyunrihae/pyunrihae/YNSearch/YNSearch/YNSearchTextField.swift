//
//  YNSearchTextField.swift
//  YNSearch
//
//  Created by YiSeungyoun on 2017. 4. 11..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class YNSearchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func initView() {
        self.leftViewMode = .always
        
        let searchImageViewWrapper = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        let searchImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        let search = UIImage(named: "search", in: Bundle(for: YNSearch.self), compatibleWith: nil)
        searchImageView.image = search
        searchImageViewWrapper.addSubview(searchImageView)
        
        self.leftView = searchImageViewWrapper
        self.returnKeyType = .search
        self.placeholder = "원하는 키워드나 상품을 검색하세요."
        self.font = UIFont.systemFont(ofSize: 14)
    }
}

open class YNSearchTextFieldView: UIView {
    open var ynSearchTextField: YNSearchTextField!
    open var cancelButton: UIButton!
    open var searchButton : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func initView() {
        self.ynSearchTextField = YNSearchTextField(frame: CGRect(x: 0, y: 0, width: self.frame.width - 50, height: self.frame.height))
        self.addSubview(self.ynSearchTextField)
        
        self.cancelButton = UIButton(frame: CGRect(x: self.frame.width - 40, y: 0, width: 50, height: self.frame.height))
        self.cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.cancelButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.cancelButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.3), for: .highlighted)
        self.cancelButton.setTitle("취소", for: .normal)
        self.cancelButton.isHidden = true
        self.addSubview(self.cancelButton)
        
        self.searchButton = UIButton(frame: CGRect(x: self.frame.width - 80, y: 0, width: 50, height: self.frame.height))
        self.searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.searchButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.searchButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.3), for: .highlighted)
        self.searchButton.setTitle("검색", for: .normal)
        self.searchButton.isHidden = true
        self.addSubview(self.searchButton)
    }

}
