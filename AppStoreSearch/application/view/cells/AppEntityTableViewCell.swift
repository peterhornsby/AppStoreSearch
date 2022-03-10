//
//  AppEntityTableViewCell.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/9/22.
//

import UIKit

@objc(AppEntityTableViewCell)
class AppEntityTableViewCell: UITableViewCell {

    static let height: CGFloat = 80.0
    
    var title: String {
        set { titleLabel.text = newValue }
        get { titleLabel.text ?? "" }
    }
    
    var icon: UIImage {
        set { logoImageView.image = newValue }
        get { logoImageView.image ?? UIImage() }
    }
    
    var version: String {
        set { versionLabel.text = "version: \(newValue)" }
        get { versionLabel.text ?? "" }
    }
    
    var size: String {
        set { sizeLabel.text = "size: \(newValue) Bytes" }
        get { sizeLabel.text ?? "" }
    }
    
    var price: String {
        set { priceLabel.text = "price: $\(newValue)" }
        get { priceLabel.text ?? "" }
    }
    
    var appId: UUID?
    
    private var shouldApplyConstraints = true

    private var logoImageView = UIImageView(frame: CGRect.zero)
    private let titleLabel = UILabel(frame: CGRect.zero)
    private let versionLabel = UILabel(frame: CGRect.zero)
    private let sizeLabel = UILabel(frame: CGRect.zero)
    private let priceLabel = UILabel(frame: CGRect.zero)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // MARK: - Reuse
    override public func prepareForReuse() {
        super.prepareForReuse()
        appId = nil
        title = ""
        version = ""
        size = ""
        price = ""
        logoImageView.image = UIImage(named: "general-no-image")
        
    }
    
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = UIColor.white
        clipsToBounds = true
        setupSubviews()
    }
    
    private func setupSubviews() {
        setupLogoImageView()
        setupTitleLabel()
        setupVersionLabel()
        setupSizeLabel()
        setupPriceLabel()
        setNeedsUpdateConstraints()
    }
    
    private func setupLogoImageView() {
        logoImageView.image = UIImage(named: "general-no-image")
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.backgroundColor = UIColor.lightGray
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = 4
        
        contentView.addSubview(logoImageView)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.clipsToBounds = true
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1
        titleLabel.preferredMaxLayoutWidth = 240.0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        
        contentView.addSubview(titleLabel)
    }
    
    private func setupVersionLabel() {
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.backgroundColor = UIColor.clear
        versionLabel.clipsToBounds = true
        versionLabel.textColor = UIColor.black
        versionLabel.lineBreakMode = .byTruncatingTail
        versionLabel.numberOfLines = 1
        versionLabel.preferredMaxLayoutWidth = 200.0
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.adjustsFontSizeToFitWidth = false
        versionLabel.minimumScaleFactor = 0.7
        contentView.addSubview(versionLabel)
    }
    
    
    private func setupSizeLabel() {
        sizeLabel.font = UIFont.systemFont(ofSize: 14)
        sizeLabel.backgroundColor = UIColor.clear
        sizeLabel.clipsToBounds = true
        sizeLabel.textColor = UIColor.black
        sizeLabel.lineBreakMode = .byTruncatingTail
        sizeLabel.numberOfLines = 1
        sizeLabel.preferredMaxLayoutWidth = 240.0
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.minimumScaleFactor = 0.7
        contentView.addSubview(sizeLabel)
    }
    
    private func setupPriceLabel() {
        priceLabel.font = UIFont.systemFont(ofSize: 13)
        priceLabel.backgroundColor = UIColor.clear
        priceLabel.clipsToBounds = true
        priceLabel.textColor = UIColor.lightGray
        priceLabel.lineBreakMode = .byTruncatingTail
        priceLabel.numberOfLines = 1
        priceLabel.preferredMaxLayoutWidth = 240.0
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.minimumScaleFactor = 0.7
        contentView.addSubview(priceLabel)
    }
    
    
    
    // MARK: - Constraints
    override public func updateConstraints() {
        if shouldApplyConstraints {
            logoImageViewContraints()
            titleLabelContraints()
            versionLabelContraints()
            sizeLabelContraints()
            priceLabelContraints()
            shouldApplyConstraints = false
        }
        
        super.updateConstraints()
    }
    
    private func logoImageViewContraints() {
        var constraints = [NSLayoutConstraint]()
        var constraint = NSLayoutConstraint(item: logoImageView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: contentView,
                                            attribute: .leading,
                                            multiplier: 1,
                                            constant: 6)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: logoImageView,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: contentView,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: 3)
        
        constraints.append(constraint)
        
        
        constraint = NSLayoutConstraint(item: logoImageView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: 74)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: logoImageView,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: 74)
        
        constraints.append(constraint)
        
        addConstraints(constraints)
    }
    
    private func titleLabelContraints() {
        var constraints = [NSLayoutConstraint]()
        var constraint = NSLayoutConstraint(item: titleLabel,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: logoImageView,
                                            attribute: .trailing,
                                            multiplier: 1,
                                            constant: 8)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: titleLabel,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: logoImageView,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: 0)
        
        constraints.append(constraint)
        
        
        constraint = NSLayoutConstraint(item: titleLabel,
                                        attribute: .trailing,
                                        relatedBy: .equal,
                                        toItem: contentView,
                                        attribute: .trailing,
                                        multiplier: 1,
                                        constant: -20)
        
        constraints.append(constraint)
        addConstraints(constraints)

    }
    
    private func versionLabelContraints() {
        var constraints = [NSLayoutConstraint]()
        var constraint = NSLayoutConstraint(item: versionLabel,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: logoImageView,
                                            attribute: .trailing,
                                            multiplier: 1,
                                            constant: 8)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: versionLabel,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: titleLabel,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0)
        
        constraints.append(constraint)
        addConstraints(constraints)
    }
    
    
    private func sizeLabelContraints() {
        var constraints = [NSLayoutConstraint]()
        var constraint = NSLayoutConstraint(item: sizeLabel,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: logoImageView,
                                            attribute: .trailing,
                                            multiplier: 1,
                                            constant: 8)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: sizeLabel,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: versionLabel,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0)
        
        constraints.append(constraint)
        addConstraints(constraints)
    }
    
    private func priceLabelContraints() {
        var constraints = [NSLayoutConstraint]()
        var constraint = NSLayoutConstraint(item: priceLabel,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: logoImageView,
                                            attribute: .trailing,
                                            multiplier: 1,
                                            constant: 8)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: priceLabel,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: logoImageView,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: -6)
        
        constraints.append(constraint)
        addConstraints(constraints)
    }
}
