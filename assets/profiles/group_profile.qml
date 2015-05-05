import bb.cascades 1.3
import bb.system 1.2
Page {
    property int popgroupid
    onCreationCompleted: {
        popgroupid = app.getPopGroupId()
        app.loadGroupMembers.connect(rendercontacts)
        app.loadGroupInfo.connect(renderinfo)
        getmembers()
        app.onMessagesEditChatTitleUpdated.connect(getmembers)
        rendercontactinfo(app.getContactInfo(popgroupid))
    }
    function  getmembers(){
        app.getGroupMembers(popgroupid)
    }
    function renderinfo(title,count){
        grouptitle.text = title
        groupstatus.text = count + " Users in this Group"
    }
    function rendercontactinfo(data){
        var info = data[0]
        grpinfopic.imageSource = filepathname.photos+"/"+info.photoid+".jpeg"
    }
    function rendercontacts(data){
        chatmemberlist.dataModel.clear()
        chatmemberlist.dataModel = data
    }
    titleBar: TitleBar {
        title: qsTr("Group Info") + Retranslate.onLanguageChanged
    }
    Container {
        horizontalAlignment: HorizontalAlignment.Center

        Container {
            topPadding: ui.du(8)
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Center
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight

            }
            leftPadding: ui.du(10)
            ImageView {
                id:grpinfopic
                imageSource: "asset:///images/thumbnails/Placeholders/group_placeholder_green.png"
                scalingMethod: ScalingMethod.None
                horizontalAlignment: HorizontalAlignment.Center
                }
            Container {
                leftPadding: ui.du(5)
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom

                }
                horizontalAlignment: HorizontalAlignment.Fill
                TextArea {
                    backgroundVisible: false
                    editable: false
                    id:grouptitle
                    text: "test"
                    editor.cursorPosition: text.length
                }
                Label {
                    id:groupstatus
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
                    rootIndexPath: [0]
                    function remfromblock(id){
                        app.removeGroupMember(popgroupid,id)
                    }
                    listItemComponents: [
                        ListItemComponent {
                            type: "item"
                            StandardListItem {
                                id:chatlistview
                                title: ListItemData.firstName + " " + ListItemData.lastName
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
            id: addfriend

            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/ic_add.png"
            title: qsTr("Add Friends") + Retranslate.onLanguageChanged
            onTriggered: {
                chatviewnav.push(groupnewuser.createObject())
            }

        },
        ActionItem {
                    id: editgroup
                    ActionBar.placement: ActionBarPlacement.OnBar
                    
                    imageSource: "asset:///images/icons/ic_edit.png"
                    onTriggered: {
                        grouptitle.requestFocus()
                        enabled=false
                        savegroup.enabled=true
                        addfriend.enabled=false
                        grouptitle.editable=true
                    }
                    title: qsTr("Edit Group") + Retranslate.onLanguageChanged

        },
        ActionItem {
            id: savegroup
            enabled: false
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/ic_save.png"
            onTriggered: {
                grouptitle.editable=false
                enabled=false
                editgroup.enabled=true
                addfriend.enabled=true
                app.saveGroupInfo(grouptitle.text)
                var grpup = app.updateGroupSettings(app.getPopGroupId(), grouptitle.text)
                if(grpup)
                {
                    grouptoast.body="saved successfully"
                    grouptoast.show()
                }
                else {
                    
                    grouptoast.body="Error in saving"
                    grouptoast.show()
                    
                }
            }
            title: qsTr("Save Settings") + Retranslate.onLanguageChanged
        
        }
    ]
    attachedObjects: [
        ComponentDefinition {
            id: groupprofileedit
            source: "group_edit_profile.qml"
        },
        ComponentDefinition {
            id: groupnewuser
            source: "group_addmember.qml"
        },
        SystemToast {
            id: grouptoast
        }
    ]

    actionBarVisibility: ChromeVisibility.Visible
    onPeekedAtChanged: {
        getmembers()
    }
    onPanePropertiesChanged: {
        getmembers()
    }
    onPeekEnded: {
        getmembers()
    }


}
