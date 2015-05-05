import bb.cascades 1.3
import bb.system 1.2
Page {
    id: newbroadcast
    property alias title: newgroupname.text
    onCreationCompleted: {
        usernames.dataModel = app.getContactsNamesModel("contact")
        app.chatgroupcreated.connect(created)
    }
    titleBar: TitleBar {
        title: qsTr("New Broadcast") + Retranslate.onLanguageChanged
    }
    function created() {
        newgroupcreatd.show()
        chatviewnav.pop()
    }
    Container {
        topPadding: ui.du(2)

        horizontalAlignment: HorizontalAlignment.Center
        TextField {
            id: newgroupname
            hintText: qsTr("Enter Broadcast Name") + Retranslate.onLanguageChanged
            preferredWidth: ui.du(50)
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            inputMode: TextFieldInputMode.Chat
            topMargin: ui.du(3)
            bottomMargin: ui.du(3)
        }
        Header {
            title: qsTr("Select Friends Of The Broadcast") + Retranslate.onLanguageChanged
            subtitle: qsTr("(Atleast One)") + Retranslate.onLanguageChanged
        
        }
        ListView {
            id: usernames
            dataModel: GroupDataModel {
            }
            multiSelectAction: MultiSelectActionItem {
            
            }
            onTriggered: {
                if(newgroupname.text.length > 0 ){
                    usernames.multiSelectHandler.active = true
                    usernames.select(indexPath)
                }
                else{ 
                    newgrouptoast.body = qsTr("Enter Broadcast Tilte") + Retranslate.onLanguageChanged
                    newgrouptoast.show()
                }
            
            }
            multiSelectHandler {
                status: qsTr("") + Retranslate.onLanguageChanged
                // The actions that can be performed in a multi-select sessions are set up in the actions list.
                actions: [
                    ActionItem {
                        title: qsTr("Save Broadcast") + Retranslate.onLanguageChanged
                        imageSource: "asset:///images/icons/ic_done.png"
                        enabled: if(newgroupname.text.length > 0) {true} else{false}
                        onTriggered: {
                           
                            var selectionList = usernames.selectionList();
                            var items = new Array();
                            for (var i = 0; i < selectionList.length ; i ++) {
                                items.push(usernames.dataModel.data(selectionList[i]).id)
                            }
                            app.createBroadCast(newgroupname.text, items,Math.floor(Math.random()*10000000))
                            chatviewnav.pop(newbroadcast)
                        }
                    }
                ]
            }
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    StandardListItem {
                        id: favcontactslist
                        title: ListItemData.firstname
                    }
                }
            ]
        }
    }
    
    attachedObjects: [
        SystemToast {
            id: newgrouptoast
            body: ""
        },
        SystemToast {
            id: newgroupcreatd
            body: qsTr("Broadcast Created") + Retranslate.onLanguageChanged
            autoUpdateEnabled: false
            button.enabled: false
        }
    ]
    actionBarVisibility: ChromeVisibility.Compact
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.Default
}
