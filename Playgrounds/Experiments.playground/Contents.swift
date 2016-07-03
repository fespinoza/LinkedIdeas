//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

struct Object {
  let a: Int
  let b: Int
  let c: Bool
}

let objects = [
  Object(a: 1, b: 4, c: true),
  Object(a: 1, b: 4, c: true),
  Object(a: 2, b: 4, c: false),
  Object(a: 1, b: 4, c: false),
  Object(a: 1, b: 4, c: true),
]
let list1 = objects.map { $0.a }
let list2 = objects.map { $0.b }
let list3 = objects.map { $0.c }

let set1 = Set(list1)
let set2 = Set(list2)
let set3 = Set(list3)

set1.count
set2.count
set2.first