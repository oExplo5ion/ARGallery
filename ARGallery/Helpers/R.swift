import Foundation
import UIKit

class R {
    
    struct Color {
        static let dark_blue_color = UIColor(red: 25/255, green: 135/255, blue: 196/255, alpha: 1)
        static let light_blue_color = UIColor(red: 79/255, green: 152/255, blue: 202/255, alpha: 1)
    }
    
    struct Image {
        static let ic_forward = UIImage(named: "ic_arrow_forward_white")
        static let ic_settings = UIImage(named: "ic_settings_white")
    }
    
    struct String {
        static let sad_emoji = "😕"
        static let thinking_emoji = "🤔"
        static let happy_emoji = "🙂"
        static let ok_option = "Ok"
        static let no_camera_text = "Camera device is not available. Try to buy newer iOS device"
        static let no_camera_alert_text = "Camera access is required for app to work. Please enable camera access."
        static let no_access_message = "Please enable access for camera and photo library in settings app"
        static let open_ar_gallery = "Open gallery"
        static let camera_access = "Camera access"
        static let photo_library_access = "Photo library access"
        static let no_images_found_text = "Images not found."
    }
    
}
