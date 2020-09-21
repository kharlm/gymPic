//
//  EquipmentBrain.swift
//  WhatFlower
//
//  Created by Kharl McCatty on 8/14/20.
//  Copyright © 2020 Kharl McCatty. All rights reserved.
//

import Foundation

struct EquipmentBrain {
    
    var equipmentNumber = 0
    var score = 0
    
    let equipment = [
        Equipment(n: "Bench Press", v: "rxD321l2svE",m: "pectoralis major"),
        Equipment(n: "Lat Pulldown", v: "CAwf7n6Luuc",m: "Latissimus dorsi muscle"),
        Equipment(n: "Leg Press", v: "KzldjgY4Mqg",m: "Quadriceps femoris muscle"),
        Equipment(n: "Shoulder Press", v: "Yq_Tj3yb5Bc",m: "Deltoid muscle"),
        Equipment(n: "Chest Press", v: "NIDP5T6enEM",m: "pectoralis major"),
        Equipment(n: "Bicep Curl", v: "M_uPvGrMx_o",m: "biceps"),
        Equipment(n: "Leg Extension", v: "IqUhWKkpub8",m: "quadriceps"),
        Equipment(n: "Smith Machine", v: "qPWXdq7idrI",m: "quadriceps"),
        Equipment(n: "Back Extension", v: "ph3pddpKzzw",m: "erector spinae"),
        Equipment(n: "Chest Fly", v: "Z57CtFmRMxA",m: "pectoralis major"),
        Equipment(n: "Leg Abductor", v: "Gff28pYH6f0",m: "pectineus muscle"),
        Equipment(n: "Seated Row", v: "GZbfZ033f74",m: "latissimus dorsi"),
        Equipment(n: "Treadmill", v: "8i3Vrd95o2k",m: "Cardiac muscle"),
        Equipment(n: "Elliptical", v: "j38LNpTLwzY",m: "Cardiac muscle"),
        Equipment(n: "Stair Climber", v: "ST-5lD69XqU",m: "gluteus maximus "),
        Equipment(n: "Leg Curl", v: "QatAMaY8eY8",m: "hamstring"),
        Equipment(n: "Shoulder Press", v: "Wqq43dKW1TU",m: "deltoid muscle"),
        Equipment(n: "Stationary Bike", v: "TZjvXjecexI",m: "Cardiac muscle")
        
        
        
        
        
       
    ]
    
    func getEquipmentVideo(equipmentName: String) -> String {
        
       let equipmentFiltered = equipment.filter{$0.name == equipmentName}
        
       return equipmentFiltered[0].video
    }
    
    func getMuscleName(equipmentName: String) -> String {
        
       let equipmentFiltered = equipment.filter{$0.name == equipmentName}
        
       return equipmentFiltered[0].muscle
    }
    
}
