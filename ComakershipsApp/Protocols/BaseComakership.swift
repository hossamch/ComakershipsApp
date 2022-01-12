//
//  BaseComakership.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 31/12/2021.
//

import Foundation

protocol BaseComakership{
    var id: Int { get }
    var name: String { get }
    var description: String { get }
    var company: ComakershipCompany { get }
    var status: ComakershipStatus? { get }
    var skills: [Skill] { get }
    var programs: [Program?] { get }
    var credits: Bool { get }
    var bonus: Bool { get }
    var createdAt: String { get }
}


