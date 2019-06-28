//
//  ViewController.swift
//  EmojiArt
//
//  Created by mingkai on 2019/6/23.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit


extension EmojiArt.EmojiInfo
{
    init?(label : UILabel){
        if let attributedText = label.attributedText, let font = label.font{
            x = Int(label.center.x)
            y = Int(label.center.y)
            text = attributedText.string
            size = Int(font.pointSize)
        }else{
            return nil
        }
    }
}

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate,
    UIScrollViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDragDelegate,
    UICollectionViewDropDelegate
{

    // life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("untitled.json"){
            if let jsonData = try? Data(contentsOf: url){
                emojiArt = EmojiArt(json: jsonData)
            }
        }
    }
    
    
    // Model
    var emojiArt : EmojiArt? {
        get{
            if let url = emojiArtBackgroundImage.url{
                let emojis = emojiArtView.subviews.compactMap { $0 as? UILabel }.compactMap{ label in
                    return EmojiArt.EmojiInfo(label: label )
                }
                return EmojiArt(url:url, emojis: emojis)
            }
            return nil
        }
        set{
            emojiArtBackgroundImage = (nil, nil)
            emojiArtView.subviews.compactMap{ $0 as? UILabel }.forEach{ $0.removeFromSuperview()}
            
            if let url = newValue?.url{
                imageFetcher = ImageFetcher(fetch: url){(url, image) in
                    DispatchQueue.main.async {
                        self.emojiArtBackgroundImage = (url, image)
                        newValue?.emojis.forEach{
                            let attributedString = $0.text.attributedString(withTextStyle: .body, ofSize: CGFloat($0.size))
                            self.emojiArtView.addLabel(with: attributedString , centeredAt: CGPoint(x: $0.x, y: $0.y))
                        }
                    }
                }
            }
            
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        if let json = emojiArt?.json{
//            if let jsonString = String(data: json, encoding: .utf8){
//                   print(jsonString)
//            }
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("untitled.json"){
                do{
                    try json.write(to: url)
                    print("save success")
                }catch let error{
                    print("save error:\(error)")
                }
            }
            
        }
        
    }
    // StoryBoard
    @IBOutlet weak var dropZone: UIView!{
        didSet{
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    private var addingEmoji = false
    
    @IBAction func addEmoji(_ sender: Any) {
        addingEmoji = true
        emojiCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
    // UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 1
        case 1:
            return emojis.count
        default:
            return 0
        }
    }
	
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if addingEmoji && indexPath.section == 0 {
            return CGSize(width: 300, height: 80)
        }
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let inputCell = cell as? TextFieldCollectionViewCell{
            inputCell.textField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var widthConstraintForScrollView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintForScrollView: NSLayoutConstraint!
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
            widthConstraintForScrollView.constant = scrollView.contentSize.width
            heightConstraintForScrollView.constant = scrollView.contentSize.height
    }
    
    private var emojis = "😀👌👆😈😭😁🐩🐶🐦⛰🐯🏃🚣🏊".map{String($0)}
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!{
        didSet{
            emojiCollectionView.delegate = self
            emojiCollectionView.dataSource = self
            emojiCollectionView.dragDelegate = self
            emojiCollectionView.dropDelegate = self
        }
    }
    
    // drag 协议支持的方法
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    // 支持多个同时选择
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    // 实现在对象上的拖拽功能获取拖拽的元素
    private func dragItems(at indexPath: IndexPath)->[UIDragItem]{
        if !addingEmoji, let attributedString = ((emojiCollectionView.cellForItem(at: indexPath)) as? EmojiCollectionViewCell)?.labelText.attributedText{
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
            dragItem.localObject = attributedString
            return [dragItem]
        }
        return []
    }
    
    // MARK: UICollectionViewDropDelegate


    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    // 仅限于section 1的drop否则取消drop
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let indexPath = destinationIndexPath, indexPath.section == 1{
            let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
            return UICollectionViewDropProposal(operation: isSelf ? .copy: .move, intent: .insertAtDestinationIndexPath)
        }else{
            return UICollectionViewDropProposal(operation: .cancel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items{
            if let sourceIndexPath = item.sourceIndexPath {
                 // 来自于collectionView本身的itemdrop
                if let attributedString = item.dragItem.localObject as? NSAttributedString {
                    // 针对模型和controller同时操作的时候可以使用批量更新
                    collectionView.performBatchUpdates({
                        self.emojis.remove(at: sourceIndexPath.item)
                        self.emojis.insert(attributedString.string, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    // 增加drop的动画
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeHolderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(
                        insertionIndexPath: destinationIndexPath,
                        reuseIdentifier: "DropPlaceHolderCell")
                )
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self){ (provider, error) in
                    DispatchQueue.main.async {
                        if let attributeString = provider as? NSAttributedString{
                            placeHolderContext.commitInsertion(dataSourceUpdates: {insertionIndexPath in
                                self.emojis.insert(attributeString.string, at: insertionIndexPath.item)
                            })
                        }else{
                            placeHolderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    
    private var font : UIFont{
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
            if let emojiCell = cell as? EmojiCollectionViewCell{
                let text = NSAttributedString(string: emojis[indexPath.item], attributes: [.font: font])
                emojiCell.labelText.attributedText = text
            }
            return cell
        }else if addingEmoji {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiInputCell", for: indexPath)
            
            if let inputCell = cell as? TextFieldCollectionViewCell{
                inputCell.resignationHandler = { [weak self, unowned inputCell] in
                    if let text = inputCell.textField.text{
                        self?.emojis = (text.map{ String($0) } + self!.emojis).uniquified
                    }
                    self?.addingEmoji=false
                    self?.emojiCollectionView.reloadData()
                }
            }
            
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddEmojiButtonCell", for: indexPath)
            return cell
        }
    }
    

    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }
    
    private var _emojiArtBackgroundImageURL: URL?
    
    var emojiArtBackgroundImage : (url:URL?, image: UIImage?){
        get {
            return (_emojiArtBackgroundImageURL,emojiArtView.backgroundImage)
        }
        set {
            _emojiArtBackgroundImageURL = newValue.url
            scrollView?.zoomScale = 1.0
            emojiArtView.backgroundImage = newValue.image
            let size = newValue.image?.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)

            scrollView?.contentSize = size
            widthConstraintForScrollView?.constant = size.width
            heightConstraintForScrollView?.constant = size.height
            
            if let dropZone = self.dropZone, size.width>0, size.height>0{
                scrollView?.zoomScale = max(dropZone.bounds.size.width/size.width, dropZone.bounds.size.height/size.height)
            }
        }
    }
    
    
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        // 只接受NSURL以及是image的内容
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        imageFetcher = ImageFetcher(){(url, image) in
            DispatchQueue.main.async {
                self.emojiArtBackgroundImage = (url, image)
            }
        }
        
        session.loadObjects(ofClass: NSURL.self){ nsurls in
            if let url = nsurls.first as? URL{
                self.imageFetcher.fetch(url)
            }
        }
        
        session.loadObjects(ofClass: UIImage.self){ images in
            if let image = images.first as? UIImage{
                self.imageFetcher.backup = image
            }
        }
        
    }
    
    var imageFetcher: ImageFetcher!
    
    
    
    var emojiArtView = EmojiArtView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

