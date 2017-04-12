//
//  DynamicCategoriesController.swift
//  House
//
//  Created by Shaun Merchant on 08/03/2017.
//  Copyright © 2017 Shaun Merchant. All rights reserved.
//

import Foundation
import HouseCore

/// A House Extension representation to the House Hub that conforms to to `DynamicCategoryController` inform House Hub
/// logic the House Extension support categories that are a subset of the House Categories protocol their type conforms to,
/// and the categories can change during runtime.
protocol DynamicCategoryController {

    /// Determine whether the House Extension supports a given category.
    ///
    /// - Parameter category: The category to determine support for.
    /// - Returns: Whether the House Extension supports the category.
    func conforms(to category: HouseCategory) -> Bool
    
}
