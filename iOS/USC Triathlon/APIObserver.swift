//
//  APIObserver.swift
//  USC Triathlon
//
//  Created by Daniel Cantwell on 2/24/16.
//  Copyright © 2016 Cantwell Code. All rights reserved.
//

import Foundation

protocol LoginListener {
    func loginSuccess(authData : NSDictionary) -> Void
    func loginFailure(error: String) -> Void
}

protocol SignUpListener {
    func signUpSuccess(uid : String) -> Void
    func signUpFailure(error: String) -> Void
}