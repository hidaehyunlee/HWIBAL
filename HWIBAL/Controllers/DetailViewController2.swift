//
//  DetailViewController.swift
//  HWIBAL
//
//  Created by daelee on 10/17/23.
//

import UIKit

final class DetailViewController: RootViewController<DetailView> {
    var data: [EmotionTrashDummy] = DummyData.generateDummyData()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension DetailViewController {}