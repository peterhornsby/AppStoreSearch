//
//  AppEntityTableViewCell.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/9/22.
//

import UIKit


class AppEntityTableViewCell: UITableViewCell {

    static let height: CGFloat = 88.0
    
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
    

    
    var appId: UUID?
    
    private var shouldApplyConstraints = true

    private var logoImageView = UIImageView(frame: CGRect.zero)
    private let titleLabel = UILabel(frame: CGRect.zero)
    private let versionLabel = UILabel(frame: CGRect.zero)


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
    
    // MARK: - Update
    func load(dataSource: AppEntity) {
        title = dataSource.name
        version = dataSource.version
        appId = dataSource.id
    }
    
    
    
    // MARK: - Reuse
    override public func prepareForReuse() {
        super.prepareForReuse()
        appId = nil
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
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
        versionLabel.font = UIFont.systemFont(ofSize: 15)
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
    
    
    
    
    // MARK: - Constraints
    override public func updateConstraints() {
        if shouldApplyConstraints {
            logoImageViewContraints()
            titleLabelContraints()
            versionLabelContraints()
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
                                        constant: 8)
        
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
                                        attribute: .centerY,
                                        relatedBy: .equal,
                                        toItem: logoImageView,
                                        attribute: .centerY,
                                        multiplier: 1,
                                        constant: -20)
        
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
}
