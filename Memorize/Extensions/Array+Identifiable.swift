//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Artem Shashulovskiy on 31.07.2020.
//  Copyright © 2020 Artem Shashulovskiy. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for i in 0..<self.count {
            if self[i].id == matching.id {
                return i
            }
        }
        return nil
    }
}
