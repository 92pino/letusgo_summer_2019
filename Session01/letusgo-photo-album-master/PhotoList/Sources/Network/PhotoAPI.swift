//
//  PhotoAPI.swift
//  PhotoList
//
//  Created by JinBae Jeong on 2019/08/03.
//  Copyright © 2019 kawoou. All rights reserved.
//

import Moya

enum PhotoApi {
    case list
    case upload(urL: URL)
}

extension PhotoApi: targetType {
    
}
