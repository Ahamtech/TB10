import bb.cascades 1.3
Page {
    titleBar: CustomSearchBar {
    
    }
    Container {
        topPadding: ui.du(2)
        DropDown {
            preferredWidth: ui.du(70)
            horizontalAlignment: HorizontalAlignment.Center
            title: qsTr("Search by") + Retranslate.onLanguageChanged
            Option {
                text: qsTr("Text") + Retranslate.onLanguageChanged
                value: "text"
            
            }
            Option {
                text: qsTr("Images") + Retranslate.onLanguageChanged
                value: "images"
            
            }Option {
                text: qsTr("Video") + Retranslate.onLanguageChanged
                value: "video"
            
            }
            Option {
                text: qsTr("Document") + Retranslate.onLanguageChanged
                value: "doc"
            
            }
            Option {
                text: qsTr("URL") + Retranslate.onLanguageChanged
                value: "url"
            
            }
        }
        Container {
            
            property alias username: displayName.text
            property alias msg: lastMessage.text
            property alias time: timestamp.text
            property bool read
            property bool incoming
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            horizontalAlignment: HorizontalAlignment.Fill
            maxHeight: 100
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Container {
                    minWidth: ui.px(100)
                    ImageView {
                        id: avatar
                        imageSource: "asset:///images/thumbnails/Placeholders/user_placeholder_cyan.png"
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill                
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
                                id: readmessage
                                imageSource: if (incoming) {
                                    read ? "asset:///images/message/read.png" : "asset:///images/message/delivered.png"
                                } else {
                                    ""
                                }
                            }
                            Label {
                                id: "searchResult"
                                text: "Message"
                                textStyle.base: SystemDefaults.TextStyles.SubtitleText
                                verticalAlignment: VerticalAlignment.Center
                            }
                        }
                    
                    }
                }
            
            }
        
        }
    }
}
