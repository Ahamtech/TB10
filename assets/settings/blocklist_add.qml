import bb.cascades 1.3

Page {
    onCreationCompleted: {
        getblock()
        app.loadBlockedUsers.connect(rendercontacts)
    }
    function getblock(){
        app.listofblockedUsers()
    }
    function rendercontacts(data){
        blockedlist.dataModel.clear()
        blockedlist.dataModel = data
        if(blockedlist.dataModel.size() == 0 ){
            blockedlist.visible = false
            noblockuser.visible = true
        } 
        else {
            blockedlist.visible = true
            noblockuser.visible = false
        }
    }
    titleBar: TitleBar {
        title: qsTr("Blocked Users") + Retranslate.onLanguageChanged
           
    }
    Container {
        horizontalAlignment: HorizontalAlignment.Center

        verticalAlignment: VerticalAlignment.Center
        layout: DockLayout {

        }
        Label {
            id: noblockuser
            text: qsTr("No users in Blocked list") + Retranslate.onLanguageChanged
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            layoutProperties: StackLayoutProperties {
            }
        }
        ListView {
            id: blockedlist
            dataModel: GroupDataModel {
                grouping: ItemGrouping.None
            }
            rootIndexPath: [0]
            function remfromblock(id){
                app.unBlockContact(id)
            }
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    StandardListItem {
                        id:blockedlistview
                        title: ListItemData.firstName + " " + ListItemData.lastName
                        contextActions: [
                            ActionSet {
                                ActionItem {
                                    title: qsTr("Unblock User") + Retranslate.onLanguageChanged
                                    imageSource: "asset:///images/thumbnails/menu_contactblock.png";                      onTriggered: {
                                        blockedlistview.ListItem.view.remfromblock(ListItemData.id)
                                    }
                                }
                            }
                        ] 
                    }
                }
            ]
            enabled: true
            visible: false
        }
    }
}
