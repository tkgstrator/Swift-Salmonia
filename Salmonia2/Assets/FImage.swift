//
//  ImageID.swift
//  Salmonia2
//
//  Created by devonly on 2020-09-22.
//

import Foundation

class FImage {
    
    class func getURL(_ id: Int, _ type: Int) -> URL{
        
        switch type {
        case 0: // Stage
            let file = stages.filter({ $0.id == id }).first!.url
            return URL(string: "https://app.splatoon2.nintendo.net/images/coop_stage/\(file)")!
        case 1: // Weapon
            let file = weapons.filter({ $0.id == id }).first!.url
            return URL(string: "https://app.splatoon2.nintendo.net/images/weapon/\(file)")!
        case 2: // Special
            let file = specials.filter({ $0.id == id }).first!.url
            return URL(string: "https://app.splatoon2.nintendo.net/images/special/\(file)")!
        case 3: // Boss Salmonids
            let file = salmonids.filter({ $0.id == id }).first!.url
            return URL(string: "https://app.splatoon2.nintendo.net/images/bundled/\(file)")!
        default:
            return URL(string: "https://cdn-image-e0d67c509fb203858ebcb2fe3f88c2aa.baas.nintendo.com/1/1e2bdb741756efcf")!
        }
    }
    
    
    class func getStageId(_ url: String) -> Int {
        stages.filter({ $0.url == url}).first?.id ?? 5000
    }
    
    
    static private let specials: [(url: String, id: Int)] = [
        // https://app.splatoon2.nintendo.net/images/special/
        ("18990f646c551ee77c5b283ec814e371f692a553.png", 2),
        ("7af300fdd872feb27b3d8e68a969457fac8b3bb7.png", 7),
        ("9871c82952ed0141be0310ace1942c9f5f66d655.png", 8),
        ("324d41e9582d84101152849bc8c96d6595c9b0ff.png", 9),
    ]
    
    static private let stages: [(url: String, name: String, id: Int)] = [
        // https://app.splatoon2.nintendo.net/images/weapon/
        ("65c68c6f0641cc5654434b78a6f10b0ad32ccdee.png", "Spawning Grounds", 5000),
        ("e07d73b7d9f0c64e552b34a2e6c29b8564c63388.png", "Marooner's Bay", 5001),
        ("6d68f5baa75f3a94e5e9bfb89b82e7377e3ecd2c.png", "Lost Outpost", 5002),
        ("e9f7c7b35e6d46778cd3cbc0d89bd7e1bc3be493.png", "Salmonid Smokeyard", 5003),
        ("50064ec6e97aac91e70df5fc2cfecf61ad8615fd.png", "Ruins of Ark Polaris", 5004),
    ]
    
    static private let salmonids: [(url: String, name: String, id: Int)] = [
        ("9b2673de42f00d4fd836bd4684741505.png", "Goldie", 3),
        ("337dde2c83705a75263aefdc15740f1c.png", "Steelhead", 6),
        ("631ea65c8cc2d9fd04f6c7458914d030.png", "Flyfish", 9),
        ("79d75f769115befab060b27401538402.png", "Scrapper", 12),
        ("2466752cf11ef6326e2add430101bff6.png", "Steel Eel", 13),
        ("862656b37d071e75ad31750c9e18ed15.png", "Stinger", 14),
        ("367e6e1c33ab3ae2a1c857f4c75f017e.png", "Maws", 15),
        ("7f8e44737240e3caa52d6c4f457164d9.png", "Griller", 16),
        ("7ecdec1e23a3d0089b38038b0217827c.png", "Drizzler", 21)
        ]
        
        static private let weapons: [(url: String, id: Int)] = [
            // https://app.splatoon2.nintendo.net/images/weapon/
            ("7076c8181ab5c49d2ac91e43a2d945a46a99c17d.png", -2),
            ("746f7e90bc151334f0bf0d2a1f0987e311b03736.png", -1),
            ("32d41a5d14de756c3e5a1ee97a9bd8fcb9e69bf5.png", 0),
            ("91b6666bcbfccc204d86f21222a8db22a27d08d0.png", 10),
            ("123db7c37066e10e2c437656db2a26f18898e6b6.png", 1000),
            ("1041dbdd11b3036671148d47c2e0798cecf3dba2.png", 1010),
            ("3d274190988ad20dd1b02825448edbb6e12c720c.png", 1020),
            ("e32ed68bb18628c5ede5816a2fbc2b8fcdd04124.png", 1030),
            ("1f94c29067c918ac9143b756dc607ff0f8cf4e63.png", 1100),
            ("f1d5740dfb7d87f7e43974bbe5585445368741b8.png", 1110),
            ("e5a97d52f12a83a037526588363021f2c1f718b0.png", 20),
            ("3f840ce3cc5ac0b8cbf7451079b57e807d8b95f1.png", 200),
            ("5a0a20324f1374a363363d721a605849e36ffff2.png", 2000),
            ("db39203d81d60a7370d3ae966bc02ed14398366f.png", 20000),
            ("7d5ff3a57c3c3aaf28217bc3a79e02d665f13ba7.png", 20010),
            ("95077fe72924bcd64f37cd43aa49a12cd6329a7e.png", 20020),
            ("c2c0653d3246ea6df2b595c68e907f68eda49b08.png", 20030),
            ("1ed94885bef2b0e498ed4dd76bea9064c85cfc94.png", 2010),
            ("0ec07bb00918f071975b35191e0860152bdcb321.png", 2020),
            ("a6279990ad871fccdd9f2a64a2951f8726f45c48.png", 2030),
            ("fd4b89e84b375f01290185f2236dbee935dd1682.png", 2040),
            ("6ecbbb897d6c59a5c03097216ef4f803366ea6fa.png", 2050),
            ("26d523e6eee3d57dc6c5f531dfc1747ffd46b8b8.png", 2060),
            ("cfafc8bc42bcd89058fdb22b7b943fb9f893adb8.png", 210),
            ("109b2b851481510eaacb50afc8ce9fb79b7f20ad.png", 220),
            ("2b684d81508ca5286060767e29dd81ca38303f43.png", 230),
            ("72bdcf5f6077bd7149832153034b3f43d16ac461.png", 240),
            ("8f64580bb033ba86fa0179179cfeb56b5544fda6.png", 250),
            ("c6ab7ebff7af7f7604eb53a12851da880b1ec2c7.png", 30),
            ("202724be5bb5e59457227d087d7c48a32c01db24.png", 300),
            ("3963a3fb1ff8038a42072e913587fc6f9aa00d71.png", 3000),
            ("ad921a57ab1b7721c50873c082bb34591b61021c.png", 3010),
            ("27a026e7dec5a068777bb7883f50451aec799d71.png", 3020),
            ("2835f6d61a4296b4ac3876337884a0c453a4fa4f.png", 3030),
            ("bf0d4b5ddc35a533fc5080d025707f386b2a5daa.png", 3040),
            ("45e8847cbaf09bdc86c6e6627236286781b09f0f.png", 310),
            ("e1d09fc9502a81c82137c8dcd5a872eb872af697.png", 40),
            ("b9901d49ef3229d3e62d58fc3e1edc8c48da6873.png", 400),
            ("2a1c5ca0e68919b4d655bd860cac3b2942b95498.png", 4000),
            ("6f42c9f8fde07510a01072a669125545f6effb99.png", 4010),
            ("e34bbd580e49695b97d5fc4464cc901d4fe08ce5.png", 4020),
            ("f208b6222acb5014ab96285e9b9a3e98039c884b.png", 4030),
            ("d79b99092aa03dc249b1f767197c1ecbda9d3cd7.png", 4040),
            ("df04ddaf086cea94491df553a6d2550230a4da3c.png", 50),
            ("cc4bc30ff53bf2b45bd5e3dadceb39d52b95761f.png", 5000),
            ("bb5caf24e43f8c7ceb126670bf24fd3aa9a3c3fc.png", 5010),
            ("7d6032f0ceee14c4607385b848c6e486b84a2865.png", 5020),
            ("aaead5ff0b63cdcb989b211d649b2552bb3e3a1b.png", 5030),
            ("ba750d284eb067abdc995435c3358eed4e6f90fa.png", 5040),
            ("1f2b1db5917ef7a4e62f0e15b8805275e33f2179.png", 60),
            ("f1fa6db2e21f32cd1c2cd093ec24f1a450d4650c.png", 6000),
            ("cdb032aa993f4836580ce4edac06de0138833299.png", 6010),
            ("15fe3fe6bbec24ddb5fdc3ffd06585bc82440531.png", 6020),
            ("2e2b59379b8f14cfed0600f84590be0ecad707b6.png", 70),
            ("df90f6065594378690647c23d42440e2de89c99d.png", 80),
            ("007fb7ed50e76dde495ffb0747421b50dfce8aa3.png", 90),
        ]
}
