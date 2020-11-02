//
//  DataModel.swift
//  WhatFlower
//
//  Created by Ekaterina Khudzhamkulova on 30.10.2020.
//

import Foundation

struct DataModel: Codable {
	let batchcomplete: Bool
	let warnings: Warnings
	let query: Query
}

// MARK: - Query
struct Query: Codable {
	let redirects: [Redirect]
	let pages: [Page]
}

// MARK: - Page
struct Page: Codable {
	let pageid, ns: Int
	let title, extract: String
}

// MARK: - Redirect
struct Redirect: Codable {
	let from, to: String
}

// MARK: - Warnings
struct Warnings: Codable {
	let extracts: Extracts
}

// MARK: - Extracts
struct Extracts: Codable {
	let warnings: String
}
