//
//  WeatherTableViewCell.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/6/24.
//

import UIKit
import SnapKit

class WeatherLabelTableViewCell: UITableViewCell, setup {
    let chatView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Layer.cornerRadius
        view.backgroundColor = .white
        return view
    }()
    
    let chatLabel: UILabel = {
        let label = UILabel()
        label.configureFont(size: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupHierarchy()
        setupConstraints()
        configureLayout()
    }
    
    func setupHierarchy() {
        contentView.addSubview(chatView)
        chatView.addSubview(chatLabel)
    }
    
    func setupConstraints() {
        chatView.snp.makeConstraints {
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(24)
            $0.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            $0.trailing.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(80)
        }
        
        chatLabel.snp.makeConstraints {
            $0.edges.equalTo(chatView).inset(12)
        }
    }
    
    private func configureLayout() {
        chatLabel.numberOfLines = 0
        
    }
    
    func configureCell(_ data: WeatherAndTemperature) {
        chatLabel.text = data.data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
