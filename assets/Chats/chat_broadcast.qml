import bb.cascades 1.3
import bb.system 1.2
import "../js/moment.js" as Moment
import "chatbubble"

Page {

    property int popbid
    onCreationCompleted: {
        textArea.requestFocus()
        popbid = app.getPopBroadCastId()
        var info = app.getMessagesModel(popbid, 0, "broadcast");
        info.reverse();
        chav.dataModel.append(info);
        rendercontactinfo(app.getContactInfo(popbid))
        chav.scrollToPosition([ ScrollPosition.End ], ScrollAnimation.None)
        textArea.requestFocus()
    }
    function rendercontactinfo(data) {
        var info = data[0]
        customTitlebrod.username = info.firstname
    }
    function updatemessages(d) {
        chav.dataModel.append(d)
        scrolltonew()
    }
    function scrolltonew() {
        chav.scrollToPosition([ ScrollPosition.End ], ScrollAnimation.Default)
    }
    titleBar: CustomTitleBrod {
        id: customTitlebrod
    }
    
    Container {
        leftPadding: 20.0
        rightPadding: 20.0
        topPadding: 20.0
        ListView {
            id: chav
            dataModel: ArrayDataModel {
                id: arraymodel
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
                                        title: "Delete Message"
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
            hintText: qsTr("Enter Your Message") + Retranslate.onLanguageChanged
            input.submitKey: SubmitKey.Send
            input.keyLayout: KeyLayout.Text
            input {
                onSubmitted: {
                    var rand = Math.floor(Math.random() * 10000000)
                    app.sendMessageBroadCast(popbid, textArea.text, rand)
                    var d = {
                        message: text,
                        id: rand,
                        date: Moment.moment().format("X"),
                        out: true
                    }
                    updatemessages(d)
                    textArea.text = ""
                }
            }
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/thumbnails/bar_send.png"
            title: qsTr("Send Message") + Retranslate.onLanguageChanged
            onTriggered: {
                var rand = Math.floor(Math.random() * 10000000)
                app.sendMessageBroadCast(popbid,textArea.text , rand)
                var d = {
                    message: textArea.text,
                    id: rand,
                    date: Moment.moment().format("X"),
                    out: true
                }
                updatemessages(d)
                textArea.text = ""
            }
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("Add Friends") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/icons/ic_add.png"
            onTriggered: {
                chatviewnav.push(groupnewuser.createObject())
            }
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("Clear History") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/thumbnails/menu_deletehistory.png"
            onTriggered: {
                clearDialog.show()
            }
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("Delete BroadCast") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/thumbnails/menu_bin.png"
            onTriggered: {
                leaveDialog.show()
            }
        }
    ]
    attachedObjects: [
        SystemDialog {
            id: leaveDialog
            title: qsTr("Do you really want to Delete the Broadcast") + Retranslate.onLanguageChanged
            customButton.enabled: false
            confirmButton.label: qsTr("Ok") + Retranslate.onLanguageChanged
            cancelButton.label: qsTr("Cancel") + Retranslate.onLanguageChanged

            onFinished: {
                if(result == SystemUiResult.ConfirmButtonSelection){
                    app.removeBroadCast(popbid)
                    chatviewnav.pop()
                }
            
            }
        },
        SystemDialog {
            id: clearDialog
            title: qsTr("Do you really want to clear Chat History") + Retranslate.onLanguageChanged
            onFinished: {
                if(result == SystemUiResult.ConfirmButtonSelection){
                    app.clearContactHistory(popbid,'broadcast')
                    chav.dataModel.clear()
                }
            }
        },
        ComponentDefinition {
            id: chatprofile
            source: "../profiles/broadcast_profile.qml"
        },
        SystemToast {
            id: chatviewtoast
            body: "So long! Thanks for coming, see you next time!"
        },
        ComponentDefinition {
            id: groupnewuser
            source: "../profiles/broadcast_addmember.qml"
        }
    ]
}
