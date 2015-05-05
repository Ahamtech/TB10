import bb.cascades 1.3

// A Custom Title bar with a differnt look then the prepackaged one.
TitleBar {
    property alias username: userNameLabel.text
    property alias status: userStatusLabel.text
    property alias searhboxinuput : searchbox.text
    property alias currentuserimage :userAvatar.imageSource
   kind: TitleBarKind.FreeForm
    
    // This is a custom title bar so we put the content (a text)
    // and an image) in a FreeFormTitleBarKindProperties.
    kindProperties: FreeFormTitleBarKindProperties {
        Container {
            Container {
                id: presenceHeaderPane
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                background: Color.create(_imBranding.getTopPaneBackgroundColor())
                
                ImageView {
                    verticalAlignment: VerticalAlignment.Center
                    id: userAvatar
                    scalingMethod: ScalingMethod.AspectFit
                    imageSource: "asset:///images/thumbnails/Placeholders/user_placeholder_blue.png"
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                chatviewnav.push(accountpage.createObject());
                            }
                        }
                    ]
                }
                Container {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 8
                    }
                    objectName: "statusContainer"
                    id: statusContainer
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        leftPadding: 10
                        topPadding: 10
                        Label {
                            verticalAlignment: VerticalAlignment.Center
                            id: userNameLabel
                            textStyle.fontWeight: FontWeight.Bold
                            text: qsTr("Syncing Please Wait") + Retranslate.onLanguageChanged
                        }
                    }
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        leftPadding: 10
                        topPadding: 10
                        Label {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Fill
                            id: userStatusLabel
                            textStyle.fontStyle: FontStyle.Italic
                        }
                    }
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                chatviewnav.push(accountpage.createObject());
                            }
                        }
                    ]
                }

                ImageView {

                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 2
                    }
                    objectName: "smallLogo"
                    id: smallLogo
                    verticalAlignment: VerticalAlignment.Center
                    scalingMethod: ScalingMethod.AspectFit
                    imageSource: "asset:///images/thumbnails/header_search.png"
                    
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                presenceHeaderPane.visible = false
                                searchHeader.visible = true
                                searchitemcont.visible = true
                                selectChats.visible = false
                                searchbox.requestFocus()
                            }
                        }
                    ]
                }
            }
            Container {
                visible: false
                id: "searchHeader"
                Container {
                    layout: DockLayout {
                    }
                    ImageView {
                        visible: _serviceId != eim ? false : true
                        imageSource: _serviceId != eim ? "" : "asset:///eim/defaultContacts/header_background.png"
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                    }
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        leftPadding: 20.0
                        topPadding: 10.0
                        rightPadding: 20.0
                        bottomPadding: 5.0
                        TextField {
                            
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1
                            }
                            hintText: qsTr("Search Name") + Retranslate.onLanguageChanged
                            id: searchbox
                            onTextChanging: {
                                contactslist.dataModel.clear()
                                contactslist.dataModel.append(app.searchFilterChatModel("", text))
                            }
                            input.submitKey: SubmitKey.Search
                            input {
                                onSubmitted: {
//                                    app.searchMessage(text)
                                    var info = contactslist.dataModel.data(contactslist.dataModel.first())
                                    var usid = info.id
                                    var type = info.type
                                    if (type == "contact") {
                                        app.setPopUserId(usid);
                                        chatviewnav.push(chatcontactpane.createObject());
                                    } else if (type == "chat") {
                                        app.setPopGroupId(usid);
                                        chatviewnav.push(chatgrouppane.createObject());
                                    } else if (type == "broadcast") {
                                        app.setPopBroadCastId(usid)
                                        chatviewnav.push(chatbroadcastpane.createObject());
                                    }
                                }
                            }
                        }
                        Button {
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: -1
                            }
                            objectName: "cancelSearchButton"
                            text: qsTr("Cancel") + Retranslate.onLanguageChanged
                            minWidth: 175.0
                            maxWidth: 175.0
                            onClicked: {
                                presenceHeaderPane.visible = true
                                searchHeader.visible = false
                                searchitemcont.visible = false
                                selectChats.visible = true
                                contactslist.dataModel.clear()
                                contactslist.dataModel.append(app.getContactsmodal(""))
                            }
                        }
                    }
                }
            }
        }
    }
    
}