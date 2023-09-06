//
//  LoginWebViewController.swift
//  FlexibleClassroom
//
//  Created by Jonathan on 2022/7/11.
//  Copyright © 2022 Agora. All rights reserved.
//

import AgoraUIBaseViews
import WebKit
import UIKit

class FcrAppUILoginWebViewController: FcrAppUIViewController {
    private var webView = WKWebView()
    
    private var url: String
    
    private var onLoginCompleted: FcrAppBoolCompletion?
    
    private var center: FcrAppCenter
    
    init(url: String,
         center: FcrAppCenter,
         onLoginCompleted: FcrAppBoolCompletion? = nil) {
        self.url = url
        self.center = center
        self.onLoginCompleted = onLoginCompleted
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true,
                                                     animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initViewFrame()
        updateViewProperties()
        loadURL()
    }
    
    private func loadURL() {
        guard let consoleURL = URL(string: url) else {
            return
        }
        
        let request = URLRequest(url: consoleURL)
        webView.load(request)
    }
    
    private func login(accessToken: String,
                       refreshToken: String) {
        center.urlGroup.accessToken = accessToken
        center.urlGroup.refreshToken = refreshToken
        
        AgoraLoading.loading()
        
        center.login { [weak self] in
            AgoraLoading.hide()
            
            self?.onLoginCompleted?(true)
        } failure: { [weak self] error in
            AgoraLoading.hide()
            
            self?.showErrorToast(error)
            self?.onLoginCompleted?(false)
        }
    }
}

extension FcrAppUILoginWebViewController: AgoraUIContentContainer {
    func initViews() {
        view.addSubview(webView)
        
        webView.navigationDelegate = self
    }
    
    func initViewFrame() {
        webView.mas_makeConstraints { make in
            make?.left.right().top().bottom().equalTo()(0)
        }
    }
    
    func updateViewProperties() {
        
    }
}

// MARK: - WKNavigationDelegate
extension FcrAppUILoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView,
                 didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url?.absoluteURL,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            decisionHandler(.allow)
            return
        }
        
        if queryItems.contains(where: {$0.name == "accessToken"}),
           queryItems.contains(where: {$0.name == "refreshToken"}) {
            
            var accessTokenValue: String?
            var refreshTokenValue: String?
            
            // Get access token and refresh token after logging in
            queryItems.forEach { item in
                if item.name == "accessToken",
                   let accessToken = item.value {
                    accessTokenValue = accessToken
                } else if item.name == "refreshToken",
                          let refreshToken = item.value {
                    refreshTokenValue = refreshToken
                }
            }
            
            decisionHandler(.cancel)
            
            guard let `accessToken` = accessTokenValue,
                  let `refreshToken` = refreshTokenValue else {
                let error = FcrAppError(code: -1,
                                        message: "Access token or refresh token retrieval failed")
                showErrorToast(error)
                onLoginCompleted?(false)
                return
            }
            
            login(accessToken: accessToken,
                  refreshToken: refreshToken)
        } else {
            decisionHandler(.allow)
        }
    }
}
