//
//  WeatherIconTableViewCell.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/7/24.
//

import UIKit
import Kingfisher
import SnapKit

class WeatherIconTableViewCell: UITableViewCell, setup {
    let chatView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Layer.cornerRadius
        view.backgroundColor = .white
        return view
    }()
    
    let chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        let url = URL(string: WeatherUrl.weatherIconUrl)
        imageView.kf.setImage(with: url)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
        configureLayout()
    }
    
    func setupHierarchy() {
        contentView.addSubview(chatView)
        chatView.addSubview(chatImageView)
    }
    
    func setupConstraints() {
        chatView.snp.makeConstraints {
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(24)
            $0.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            $0.trailing.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(80)
        }
        
        chatImageView.snp.makeConstraints {
            $0.edges.equalTo(chatView).inset(16)
            $0.size.equalTo(120)
        }
    }
    
    private func configureLayout() {
        self.backgroundColor = .clear
    }
    
    func configureCell(_ data: WeatherAndTemperature) {
        let url = URL(string: data.data)
        chatImageView.kf.setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
