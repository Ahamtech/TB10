import bb.cascades 1.3

Container {

    property alias username: displayName.text
    property alias msg: lastMessage.text
    property alias time: timestamp.text

    property variant type
    property variant photoid
    property bool read
    property bool incoming
    property variant path
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    onCreationCompleted: {
        console.log(path)
    }
    horizontalAlignment: HorizontalAlignment.Fill
    maxHeight: 100
    function userimage(type,src) {
        if (src) {
            console.log(path)
            return path +"/"+src+".jpeg"
            
        } else{
            switch (type) {
            case "contact":
                {
                    return "asset:///images/thumbnails/Placeholders/user_placeholder_blue.png";
                    break;
                }
            case "chat":
                {
                    return "asset:///images/thumbnails/Placeholders/group_placeholder_green.png";
                    break;
                }
            case "broadcast":
                {
                    return "asset:///images/thumbnails/Placeholders/broadcast_placeholder_yellow.png";
                    break;
                }
        }
}
}
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Container {
            minWidth: ui.px(100)
            ImageView {
                animations: [
                    ParallelAnimation {
                        id: imgani
                        
                        FadeTransition {
                            fromOpacity: 0
                            toOpacity: 1
                            duration: 1000
                        }
                        ScaleTransition {
                            fromX: 0
                            fromY: 0
                            duration: 1000
                        }
                        TranslateTransition {
                            fromX: 0
                            fromY: 0
                            duration: 1000
                        }
                    }
                ]
                id: avatar
                imageSource: userimage(type,photoid)
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                onCreationCompleted: {
                    imgani.play()
//                    console.log("Creation compeleted"+imageSource, displayName.text)
                }
            }
            
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                leftPadding: 10
                topPadding: 5
                horizontalAlignment: HorizontalAlignment.Left
                
                Label {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                    verticalAlignment: VerticalAlignment.Center
                    id: "displayName"
                    text: "Username"
                }
                Label {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: -1

                    }
                    id: "timestamp"
                    text: ""
                    horizontalAlignment: HorizontalAlignment.Right
                    textStyle {
                        base: SystemDefaults.TextStyles.SubtitleText
                    }
                }
                ImageView {
                    visible: incoming
                    maxHeight: 40
                    maxWidth: 40
                    imageSource: "asset:///images/icons/bell.png"

                }
            }
            Container {

                leftPadding: 10
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                }

                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    ImageView {
                        minHeight: 40
                        minWidth: 40
                        id: readmessage
                        imageSource: if (incoming) {
                            read ? "asset:///images/message/read.png" : "asset:///images/message/delivered.png"
                        } else {
                            ""
                        }
                    }
                    Label {
                        id: "lastMessage"
                        text: "Message"
                        textStyle.base: SystemDefaults.TextStyles.SubtitleText
                        verticalAlignment: VerticalAlignment.Center
                    }
                }

            }
        }

    }

}
