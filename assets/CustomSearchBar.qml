import bb.cascades 1.3

TitleBar {
    kind: TitleBarKind.FreeForm
    kindProperties: FreeFormTitleBarKindProperties {
        Container {
            visible: true
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
                        hintText: qsTr("Search Messages") + Retranslate.onLanguageChanged
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
                bottomPadding: ui.du(2)
            }
        }

    }
}
    