//
//  Array+onlt.swift
//  Memorize
//
//  Created by Artem Shashulovskiy on 31.07.2020.
//  Copyright © 2020 Artem Shashulovskiy. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
