import bb.cascades 1.3
import bb.system 1.2

Page {
    property int popbid

    onCreationCompleted: {
        popbid = app.getPopBroadCastId()
        app.broadcastlistmembersupdate.connect(renderview)
        renderview()
    }
    function renderview(){
        renderinfo(app.getContactInfo(popbid))
        chatmemberlist.dataModel = app.getBroadCastMembers(popbid)
        broadcastdes.text =  chatmemberlist.dataModel.size() +" members"
    }
    function renderinfo(title) {
        var info = title[0]
        broadcasttitle.text = info.firstname
    }
    function renderdes(info) {
        broadcastdes.text = info
    }
    function rendercontacts() {
        chatmemberlist.dataModel.clear()
        chatmemberlist.dataModel = app.getBroadCastMembers(popbid)
    }

    titleBar: TitleBar {
        title: qsTr("Broadcast Info") + Retranslate.onLanguageChanged

    }
    Container {

        Container {
            topPadding: ui.du(8)
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight

            }
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            ImageView {
                imageSource: "asset:///images/thumbnails/Placeholders/broadcast_placeholder_yellow.png"
                scalingMethod: ScalingMethod.None

            }
            Container {
                leftPadding: ui.du(5)
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom

                }
                TextArea {
                    
                    editable: false
                    backgroundVisible: false
                    id: broadcasttitle
                    text: qsTr("Broadcast Name") + Retranslate.onLanguageChanged
                

                }
                TextArea {
                    editable: false
                    backgroundVisible: false
                    id: broadcastdes
                    text: qsTr("online status..") + Retranslate.onLanguageChanged
                }
            }
        }
        Container {
            leftPadding: ui.du(5)
            rightPadding: ui.du(5)
            topPadding: ui.du(5)

            Divider {
                horizontalAlignment: HorizontalAlignment.Center
            }

            Container {
                topPadding: ui.du(1)
                ListView {
                    id: chatmemberlist
                    dataModel: GroupDataModel {
                        grouping: ItemGrouping.None
                    }
                    rootIndexPath: [ 0 ]
                    function remfromblock(id) {
                        app.removeBroadCastMember(popbid, id)
                        chatmemberlist.dataModel = app.getBroadCastMembers(popbid)
                    }
                    listItemComponents: [
                        ListItemComponent {
                            type: "item"
                            StandardListItem {
                                id: chatlistview
                                title: ListItemData.firstname
                                contextActions: [
                                    ActionSet {
                                        ActionItem {
                                            title: qsTr("Remove User") + Retranslate.onLanguageChanged
                                            onTriggered: {
                                                chatlistview.ListItem.view.remfromblock(ListItemData.id)
                                            }
                                            imageSource: "asset:///images/thumbnails/menu_bin.png"
                                        }
                                    }
                                ]
                            }
                        }
                    ]
                }
            }

        }

    }
    actions: [
        ActionItem {
            id: addbroadcast
            ActionBar.placement: ActionBarPlacement.OnBar
            title: qsTr("Add Friends") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/icons/ic_add.png"
            onTriggered: {
                chatviewnav.push(groupnewuser.createObject())
            }
        },
        ActionItem {
            id: editbroadcast
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/ic_edit.png"
            onTriggered: {
                enabled=false
                broadcastsave.enabled=true
                addbroadcast.enabled =false
                broadcasttitle.editable=true
            }
            title: qsTr("Edit Broadcast") + Retranslate.onLanguageChanged
        },
        ActionItem {
            id: broadcastsave
            enabled: false
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/ic_save.png"
            onTriggered: {
                enabled=false
                addbroadcast.enabled=true
                editbroadcast.enabled=true
                broadcasttitle=false
                var bid = app.getPopBroadCastId()
                var upex = app.updateBroadCast(bid,broadcasttitle.text)
                if(upex){
                    broadtoast.body="saved successfully"
                    broadtoast.show();
                }
                else {
                    broadtoast.body="error in saving"
                    broadtoast.show();
                }
            }
            title: qsTr("Save Settings") + Retranslate.onLanguageChanged
        }

    ]
    attachedObjects: [
        ComponentDefinition {
            id: groupprofileedit
            source: "broadcast_edit_profile.qml"
        },
        ComponentDefinition {
            id: groupnewuser
            source: "broadcast_addmember.qml"
        },
    SystemToast {
        id: broadtoast
    }
    ]
    actionBarVisibility: ChromeVisibility.Visible
}
