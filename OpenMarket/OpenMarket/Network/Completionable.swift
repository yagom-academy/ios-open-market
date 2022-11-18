//
//  Completionable.swift
//  OpenMarket
//
//  Created by Jpush, Aaron on 2022/11/15.
//

protocol Completionable {}

typealias StatusCode = Int

extension StatusCode: Completionable {}
extension ProductsList: Completionable {}
extension Product: Completionable {}
