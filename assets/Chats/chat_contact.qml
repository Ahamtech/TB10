import bb.cascades 1.3
import bb.system 1.2
import bb.cascades.pickers 1.0

import "../js/moment.js" as Moment
import "chatbubble"

Page {

    property int popuserid
    property int toplimit
    property bool reloadchat

    onCreationCompleted: {
        popuserid = app.getPopUserId()
        initloadchat()
        app.historyloaded.connect(chacheloadchat)
        app.updatemessage.connect(updatemessages)
        app.livechatdeletemessage.connect(delmessagelive)
        rendercontactinfo(app.getContactInfo(popuserid))
        app.usertyping.connect(typing)
        app.stoptyping.connect(stoptyping)
        app.messageread.connect(messageread)
        chav.scrollToPosition([ ScrollPosition.End ], ScrollAnimation.None)
        textArea.requestFocus()
    }
    function initloadchat() {
        var info = app.getMessagesModel(popuserid, 0, "contact");
        info.reverse()
        chav.dataModel.append(info)
        if (chav.dataModel.size() > 0) {
            emptychat.visible = false
            openchat.visible = true
            scrolltonew()
            var data = app.getContactInfo(popuserid)
            var info = data[0]
            if (info.init == "true") {
                reloadchat = true
                app.setinitfalse(popuserid)
                app.getmessages(popuserid, "contact", 0)
            }
        } else {
            emptychat.visible = true
            openchat.visible = false
            app.getmessages(popuserid, "contact", 0)
        }
    }
    function chacheloadchat() {
        if (reloadchat == true) {
            chav.dataModel.clear()
            reloadchat = false
        }
        var info = app.getMessagesModel(popuserid, chav.dataModel.size(), "contact");
        if (info.length > 0) {
            toggleempty()
            info.reverse()
            chav.dataModel.insert(0, info)
            loadingMessage.visible = false
            chav.scrollToItem(chav.dataModel.value(info.length - 2))
        } else {
            if (toplimit == chav.dataModel.size()) {
                loadingMessage.visible = false
            } else {
                app.getmessages(popuserid, "contact", chav.dataModel.size())
                toplimit = chav.dataModel.size()
            }
        }
    }

    function delmessagelive(data) {
        chav.dataModel.removeAt(chav.dataModel.indexOf(data))
    }
    function typing() {
        typinguser.visible = true
    }
    function stoptyping() {
        typinguser.visible = false
    }
    function updatemessages(d) {
        emptychat.visible = false
        openchat.visible = true
        if (d.type == "contact" && (d.fromId == popuserid || d.toId == popuserid)) {
            chav.dataModel.append(d)
            typinguser.visible = false
            scrolltonew()
        }
    }

    function toggleempty() {
        emptychat.visible = false
        openchat.visible = true
    }
    function scrolltonew() {
        chav.scrollToPosition([ ScrollPosition.End ], ScrollAnimation.Default)
        markallread()
    }
    function markallread() {
        var last = chav.dataModel.value(chav.dataModel.size() - 1)
        app.markReadMessages(last.id, popuserid, "contact")
    }
    function rendercontactinfo(data) {
        var info = data[0]
        
        custom_titlechat.username = info.firstname + " " + info.lastname
        if (info.photoid) {
            custom_titlechat.avatar = filepathname.photos +"/" +info.photoid + ".jpeg"
        }
        if(info.wasonline != 0 || info.wasonline != null || info.wasonline != "" ){
            custom_titlechat.status = Moment.moment.unix(info.wasonline).calendar()
        }
    }
    function messageread(id) {
        for (var i = 0; i < chav.dataModel.size(); i ++) {
            if (chav.dataModel.value(i).id = id) {
                var item = chav.dataModel.value(i)
                item.read = true
                chav.dataModel.replace(i, item)
            }
        }
    }
    titleBar: CustomTitleChat {
        id: custom_titlechat
    }
    Container {
        /*Container {
         * gestureHandlers: [
         * TapHandler {
         * onTapped: {
         * chatviewnav.push(chatprofile.createObject())
         * }
         * }
         * ]
         * layout: StackLayout {
         * orientation: LayoutOrientation.LeftToRight
         * }
         * topPadding: 6
         * bottomPadding: 6
         * leftPadding: 6
         * maxHeight: 120
         * 
         * horizontalAlignment: HorizontalAlignment.Fill
         * verticalAlignment: VerticalAlignment.Fill
         * background: Color.Gray
         * ImageView {
         * 
         * verticalAlignment: VerticalAlignment.Center
         * objectName: "avatarImage"
         * id: userAvatar
         * 
         * scalingMethod: ScalingMethod.AspectFit
         * maxWidth: 110
         * minWidth: 110
         * maxHeight: 110
         * minHeight: 110
         * imageSource: "asset:///images/thumbnails/Placeholders/user_placeholder_purple.png"
         * //property int _currentPane: 0
         * 
         * }
         * Container {
         * layoutProperties: StackLayoutProperties {
         * spaceQuota: 8
         * }
         * objectName: "statusContainer"
         * id: statusContainer
         * Container {
         * layout: StackLayout {
         * orientation: LayoutOrientation.LeftToRight
         * }
         * leftPadding: 10
         * topPadding: 5
         * Label {
         * verticalAlignment: VerticalAlignment.Center
         * objectName: "nameLabel"
         * id: userNameLabel
         * textStyle.base: SystemDefaults.TextStyles.BodyText
         * text: "Contact Name"
         * }
         * }
         * Container {
         * layout: StackLayout {
         * orientation: LayoutOrientation.LeftToRight
         * }
         * leftPadding: 10
         * topPadding: 10
         * Label {
         * verticalAlignment: VerticalAlignment.Center
         * horizontalAlignment: HorizontalAlignment.Fill
         * objectName: "statusLabel"
         * id: userStatusLabel
         * text: qsTr("Contact Status") + Retranslate.onLanguageChanged
         * textStyle.base: SystemDefaults.TextStyles.SmallText
         * content.flags: TextContentFlag.Emoticons
         * }
         * }
         * 
         * }
         }*/

        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            Label {
                id: loadingMessage
                visible: false
                text: qsTr("Loading Messages ....") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
            }
            Label {
                id: typinguser
                visible: false
                text: qsTr("Typing .... ") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
            }
            Label {
                id: refreshingcache
                visible: false
                text: qsTr("refreshing .... ") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
        Container {
            layout: DockLayout {
            }
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            Container {
                id: emptychat
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                visible: true
                layout: StackLayout {
                }
                Label {
                    text: qsTr("Loading Previous Messages If Any") + Retranslate.onLanguageChanged
                    horizontalAlignment: HorizontalAlignment.Center

                }
                Label {

                    text: qsTr("Start chatting") + Retranslate.onLanguageChanged
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
            Container {
                id: openchat
                visible: true
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                layoutProperties: AbsoluteLayoutProperties {

                }
                ListView {
                    id: chav
                    dataModel: ArrayDataModel {
                        id: arraymodel
                    }
                    leadingVisual: LoadChat {
                        onLiveChatLoading: {
                            loadingMessage.visible = true
                            chacheloadchat()
                        }
                    }
                    onTriggered: {
                        var data = chav.dataModel.indexOf(indexPath)
                        if (data.type == "geo") {
                        }

                    }
                    function deletemessage(data) {
                        var bool = app.deleteMessage(data.id)
                        if (bool == true) {
                            chatviewtoast.body = qsTr("Message Deleted ") + Retranslate.onLanguageChanged
                            chav.dataModel.removeAt(chav.dataModel.indexOf(data))
                        } else {
                            chatviewtoast.body = qsTr("Error Deleting Message") + Retranslate.onLanguageChanged
                        }
                        chatviewtoast.show()
                    }

                    function copytoclip(text) {
                        app.copyText(text)
                    }
                    function fwdmessage(id) {
                        app.stashFwdMessage(id)
                        chatviewnav.push(fwdmessagepane.createObject())
                    }
                    listItemComponents: [
                        ListItemComponent {
                            type: ""
                            CustomListItem {
                                id: listofmessagesincontact
                                dividerVisible: false
                                highlightAppearance: HighlightAppearance.Frame
                                ControlDelegate {
                                    sourceComponent: chatbubble
                                    attachedObjects: [
                                        ComponentDefinition {
                                            id: chatbubble
                                            Bubble {
                                                message: ListItemData.message
                                                time: Moment.moment.unix(ListItemData.date).calendar()
                                                incoming: ListItemData.out
                                                read: ListItemData.read
                                                type: ListItemData.type
                                            }
                                        }
                                    ]
                                    contextActions: [
                                        ActionSet {

                                            ActionItem {
                                                title: qsTr("Copy") + Retranslate.onLanguageChanged
                                                imageSource: "asset:///images/icons/ic_copy.png"
                                                onTriggered: {
                                                    listofmessagesincontact.ListItem.view.copytoclip(ListItemData.message)
                                                }
                                            }
                                            ActionItem {
                                                title: qsTr("Forward") + Retranslate.onLanguageChanged
                                                imageSource: "asset:///images/icons/ic_forward.png"
                                                onTriggered: {
                                                    listofmessagesincontact.ListItem.view.fwdmessage(ListItemData.id)
                                                }
                                            }
                                            /*ActionItem {
                                             * title: qsTr("Share") + Retranslate.onLanguageChanged
                                             * imageSource: "asset:///images/icons/ic_share.png"
                                             * onTriggered: {
                                             * 
                                             * }
                                             }*/
                                            ActionItem {
                                                title: qsTr("Delete Message") + Retranslate.onLanguageChanged
                                                imageSource: "asset:///images/icons/ic_delete.png"
                                                onTriggered: {
                                                    listofmessagesincontact.ListItem.view.deletemessage(ListItemData)
                                                }
                                            }
                                        }
                                    ]
                                }
                            }
                        }
                    ]
                    bufferedScrollingEnabled: true
                }
            }
        }
    }
    actions: [
        TextInputActionItem {
            id: textArea
            text: ""
            hintText: qsTr("Enter Message") + Retranslate.onLanguageChanged
            input.submitKey: SubmitKey.Send
            onTextChanging: {
                app.sendTyping(popuserid, true)
            }
            title: "Type"
            textFormat: TextFormat.Auto
            input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Keep
            input {
                onSubmitted: {
                    app.sendMessage(textArea.text, Math.floor(Math.random() * 10000000))
                    textArea.text = ""
                }
            }
            onStatusChanged: {
                scrolltonew()
            }
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.OnBar
            title: qsTr("Send Message") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/thumbnails/menu_bar_chat.png"
            onTriggered: {
                app.sendMessage(textArea.text, Math.floor(Math.random() * 10000000))
                textArea.text = ""
            }
        },
        ActionItem {
            title: qsTr("Send File") + Retranslate.onLanguageChanged
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/icons/ic_attach.png"
        },
//        ActionItem {
//            title: qsTr("Chat Background") + Retranslate.onLanguageChanged
//            ActionBar.placement: ActionBarPlacement.InOverflow
//            imageSource: "asset:///images/thumbnails/bar_gallery.png"
//            onTriggered: {
//                filePicker.open()
//            }
//        }
        ActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("Block Contact") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/thumbnails/menu_contactblock.png"
            onTriggered: {
                blockuserDialog.show()
            }
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("Clear History") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/icons/ic_clear_list.png"
            onTriggered: {
                clearchatDialog.show()
            }
        }

    ]

    attachedObjects: [
        SystemDialog {
            id: blockuserDialog
            title: qsTr("Do you really want to this Block User") + Retranslate.onLanguageChanged
            customButton.enabled: false
            confirmButton.label: qsTr("Ok") + Retranslate.onLanguageChanged
            cancelButton.label: qsTr("Cancel") + Retranslate.onLanguageChanged

            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    app.blockUserContact(popuserid)
                }

            }
        },
        SystemDialog {
            id: clearchatDialog
            title: qsTr("Do you really want to Clear History") + Retranslate.onLanguageChanged
            customButton.enabled: false
            confirmButton.label: qsTr("Ok") + Retranslate.onLanguageChanged
            cancelButton.label: qsTr("Cancel") + Retranslate.onLanguageChanged

            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    app.clearContactHistory(popuserid, 'contact')
                    chav.dataModel.clear()
                }
            }
        },
        SystemToast {
            id: chatviewtoast
        },
        ComponentDefinition {
            id: fwdmessagepane
            source: "forward_allchats.qml"
        },
        ComponentDefinition {
            id: chatprofile
            source: "../profiles/contact_profile.qml"
        }
    ]
}
