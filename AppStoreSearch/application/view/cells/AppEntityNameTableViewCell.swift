//
//  AppEntityNameTableViewCell.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/10/22.
//

import UIKit

class AppEntityNameTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 200.0
    
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
        set {
            if newValue == "0.0" {
                priceLabel.text = "price: FREE"
            } else {
                priceLabel.text = "price: $\(newValue)"
            }
        }
        get { priceLabel.text ?? "" }
    }
    
    
    private var logoImageView = UIImageView(frame: CGRect.zero)
    private let titleLabel = UILabel(frame: CGRect.zero)
    private let versionLabel = UILabel(frame: CGRect.zero)
    private let sizeLabel = UILabel(frame: CGRect.zero)
    private let priceLabel = UILabel(frame: CGRect.zero)
    private var shouldApplyConstraints = true

    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Update
    func load(dataSource: AppEntity) {
        title = dataSource.name
        version = dataSource.version
        price = dataSource.price
        size = dataSource.size
    }
    
    
    
    // MARK: - Reuse
    override public func prepareForReuse() {
        super.prepareForReuse()
        title = ""
        version = ""
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
        logoImageView.layer.cornerRadius = 8
        
        contentView.addSubview(logoImageView)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.clipsToBounds = true
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 2
        titleLabel.preferredMaxLayoutWidth = 240.0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        
        contentView.addSubview(titleLabel)
    }
    
    private func setupVersionLabel() {
        versionLabel.font = UIFont.systemFont(ofSize: 23)
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
                                            constant: 20)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: logoImageView,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: contentView,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: 40)
        
        constraints.append(constraint)
        
        
        constraint = NSLayoutConstraint(item: logoImageView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: 120)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: logoImageView,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: 120)
        
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
                                        constant: -4)
        
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
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: sizeLabel,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 3)
        
        constraints.append(constraint)
        addConstraints(constraints)
    }
}
