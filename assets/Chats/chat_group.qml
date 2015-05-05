import bb.cascades 1.3
import bb.system 1.2
import "../js/moment.js" as Moment
import "chatbubble"
Page {
    property int popgroupid
    property int toplimit
    property bool reloadchat
    property variant name: app.getidtousers()

    function renderinfo(title, count, grpid, active) {
        customTitleGrp.status = count + " members"
        customTitleGrp.username = title
        if (active) {
            textArea.setEnabled(false)
            textArea.hintText = "No Longer in this group"
            sendbutton.enabled = false
            deletgroup.enabled = true
        }
    }
    onCreationCompleted: {
        popgroupid = app.getPopGroupId();
        app.getGroupInfo(popgroupid)
        app.loadGroupInfo.connect(renderinfo)
        Qt.name = name
        popgroupid = app.getPopGroupId();
        app.getGroupInfo(popgroupid)
        initloadchat();
        app.historyloaded.connect(chacheloadchat)
        app.updatemessage.connect(updatemessages)
        app.livechatdeletemessage.connect(delmessagelive)
        rendercontactinfo(app.getContactInfo(popgroupid))
        app.usertypinggroup.connect(typing)
        app.stoptypinggroup.connect(stoptyping)
        textArea.requestFocus()
        chav.scrollToPosition([ ScrollPosition.End ], ScrollAnimation.None)
    }

    function initloadchat() {
        var info = app.getMessagesModel(popgroupid, 0, "chat");
        info.reverse()
        chav.dataModel.append(info)
        if (chav.dataModel.size() > 0) {
            scrolltonew()
            var data = app.getContactInfo(popgroupid)
            var info = data[0]
            if (info.init == "true") {
                reloadchat = true
                app.setinitfalse(popgroupid)
                app.getmessages(popgroupid, "chat", 0)
            }
        } else {
            app.getmessages(popgroupid, "chat", 0)
        }
    }
    function chacheloadchat() {
        if (reloadchat == true) {
            chav.dataModel.clear()
            reloadchat = false
        }
        var info = app.getMessagesModel(popgroupid, chav.dataModel.size(), "chat");
        if (info.length > 0) {
            info.reverse()
            chav.dataModel.insert(0, info)
            loadingMessage.visible = false
            chav.scrollToItem(chav.dataModel.value(info.length - 2))
        } else {
            if (toplimit == chav.dataModel.size()) {
                loadingMessage.visible = false
            } else {
                app.getmessages(popgroupid, "chat", chav.dataModel.size())
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
        if (d.type == "chat" && (d.fromId == popgroupid || d.toId == popgroupid )) {
            chav.dataModel.append(d)
            typinguser.visible = false
            scrolltonew()
        }
    }
    function scrolltonew() {
        chav.scrollToPosition([ ScrollPosition.End ], ScrollAnimation.Default)
        markallread()
    }
    function markallread() {
        var last = chav.dataModel.value(chav.dataModel.size() - 1)
        if (last) {
            app.markReadMessages(last.id, popgroupid, "chat")
        }
    }
    function rendercontactinfo(data) {
        var info = data[0]
        customTitleGrp.username = info.firstname
        customTitleGrp.avatar = filepathname.photos +"/" +info.photoid + ".jpeg"
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
    titleBar: CustomTitleGroup {
        id: customTitleGrp
    }
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
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
        }
        layoutProperties: AbsoluteLayoutProperties {

        }
        ListView {
            id: chav
            property variant name
            dataModel: ArrayDataModel {

            }
            leadingVisual: LoadChat {
                onLiveChatLoading: {
                    loadingMessage.visible = true
                    chacheloadchat()
                }
            }

            function deletemessage(data) {
                var bool = app.deleteMessage(data.id)
                if (bool == true) {
                    chatviewtoast.body = "Message Deleted"
                    chav.dataModel.removeAt(chav.dataModel.indexOf(data))
                } else {
                    chatviewtoast.body = "Error Deleting Message"
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
                        ControlDelegate {
                            sourceComponent: chatbubble
                            attachedObjects: [
                                ComponentDefinition {
                                    id: chatbubble

                                    Bubble {

                                        id: bubble
                                        time: Moment.moment.unix(ListItemData.date).calendar()
                                        message: ListItemData.message
                                        incoming: ListItemData.out
                                        username: ListItemData.out == "false" ? Qt.name[ListItemData.fromId] : Qt.name[ListItemData.toId]
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
                                        title: qsTr("Share") + Retranslate.onLanguageChanged
                                        imageSource: "asset:///images/icons/ic_share.png"
                                        onTriggered: {

                                        }
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
        }
    }

    actions: [
        TextInputActionItem {
            id: textArea
            text: ""
            hintText: qsTr("Enter your message") + Retranslate.onLanguageChanged
            input.submitKey: SubmitKey.Send
            input.keyLayout: KeyLayout.Text
            input {
                onSubmitted: {
                    app.sendMessageChat(textArea.text, Math.floor(Math.random() * 10000000))
                    textArea.text = ""
                }
            }

        },
        ActionItem {
            id: sendbutton
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/thumbnails/bar_send.png"
            onTriggered: {
                onSubmitted:
                {
                    app.sendMessageChat(textArea.text, Math.floor(Math.random() * 10000000))
                    textArea.text = ""
                }
            }
            title: qsTr("Send message") + Retranslate.onLanguageChanged
        },
        ActionItem {

            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/icons/ic_add_to_contacts.png"
            title: qsTr("Add Friends") + Retranslate.onLanguageChanged
            onTriggered: {
                chatviewnav.push(groupnewuser.createObject())
            }

        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("Delete Group") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/thumbnails/menu_deletehistory.png"
            onTriggered: {
                clearDialog.show()
            }
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("Leave Group") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/thumbnails/menu_bin.png"
            onTriggered: {
                leaveDialog.show()
            }
        }
       /*, ActionItem {
            id: deletgroup
            title: qsTr("Delete Group") + Retranslate.onLanguageChanged
            enabled: false
            onTriggered: {
                app.deleteGroup(popgroupid)
                chatviewnav.pop()
            }

        }*/

    ]
    attachedObjects: [
        SystemDialog {
            id: leaveDialog
            title: qsTr("Do you really want to Leave the group") + Retranslate.onLanguageChanged
            customButton.enabled: false
            confirmButton.label: qsTr("Ok") + Retranslate.onLanguageChanged
            cancelButton.label: qsTr("Cancel") + Retranslate.onLanguageChanged
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    app.leaveGroup(popgroupid)
                    chatviewnav.pop()
                }
            }
        },
        SystemDialog {
            id: clearDialog
            title: qsTr("Do you really want to Delete the group") + Retranslate.onLanguageChanged

            //add this function to OK button
            /**/

            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    app.clearContactHistory(popgroupid, 'chat')
                    chav.dataModel.clear()
                }

            }
        },
        SystemToast {
            id: chatviewtoast
            body: "So long! Thanks for coming, see you next time!"
        },
        ComponentDefinition {
            id: fwdmessagepane
            source: "forward_allchats.qml"
        },
        ComponentDefinition {
            id: groupnewuser
            source: "../profiles/group_addmember.qml"
        },
        ComponentDefinition {
            id: groupprofile
            source: "../profiles/group_profile.qml"
        }
        
    ]
}
