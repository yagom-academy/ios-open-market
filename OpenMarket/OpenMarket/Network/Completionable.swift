//
//  Completionable.swift
//  OpenMarket
//
//  Created by 이정민 on 2022/11/15.
//

protocol Completionable {}

typealias StatusCode = Int

extension StatusCode: Completionable {}
extension ProductsList: Completionable {}
extension Product: Completionable {}
