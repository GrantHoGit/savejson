import QtQuick 2.4
import Ubuntu.Components 1.2
import Savejson 1.0
import "savedata.js" as Data

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "savejson.liu-xiao-guo"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(60)
    height: units.gu(85)

    Page {
        id: mainPage
        title: i18n.tr("savejson")
        property string path: ""

        FileIO {
            id: fileio
            source: "sample.json"
        }

        // The model:
        ListModel {
            id: fruitModel

            objectName: "fruitModel"

            ListElement {
                name: "Apple"; cost: 2.45
                image: "pics/apple.jpg"
                description: "Deciduous"
            }
            ListElement {
                name: "Banana"; cost: 1.95
                image: "pics/banana.jpg"
                description: "Seedless"
            }
            ListElement {
                name: "Cumquat"; cost: 3.25
                image: "pics/cumquat.jpg"
                description: "Citrus"
            }
            ListElement {
                name: "Durian"; cost: 9.95
                image: "pics/durian.jpg"
                description: "Tropical Smelly"
            }
        }

        Component {
            id: listDelegate

            ListItem {
                id: delegateItem
                width: listView.width; height: units.gu(10)
                onPressAndHold: ListView.view.ViewItems.dragMode =
                                !ListView.view.ViewItems.dragMode

                Image {
                    id: pic
                    height: parent.height - units.gu(1)
                    width: height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(0.5)
                    source: image
                }

                Column {
                    id: content
                    anchors.top: parent.top
                    anchors.left: pic.right
                    anchors.leftMargin: units.gu(2)
                    anchors.topMargin: units.gu(1)
                    width: parent.width - pic.width - units.gu(1)
                    height: parent.height
                    spacing: units.gu(1)

                    Label {
                        text: name
                    }

                    Label { text: description }

                    Label {
                        text: '$' + Number(cost).toFixed(2)
                        font.bold: true
                    }
                }


                trailingActions: ListItemActions {
                    actions: [
                        Action {
                            iconName: "add"

                            onTriggered: {
                                console.log("add is triggered!");
                                fruitModel.setProperty(index, "cost", cost + 0.25);
                            }
                        },
                        Action {
                            iconName: "remove"

                            onTriggered: {
                                console.log("remove is triggered!");
                                fruitModel.setProperty(index, "cost", Math.max(0,cost-0.25));
                            }
                        },
                        Action {
                            iconName: "delete"

                            onTriggered: {
                                console.log("delete is triggered!");
                                fruitModel.remove(index)
                            }
                        }
                    ]
                }

                color: dragMode ? "lightblue" : "lightgray"

                ListView.onAdd: SequentialAnimation {
                    PropertyAction { target: delegateItem; property: "height"; value: 0 }
                    NumberAnimation { target: delegateItem; property: "height"; to: delegateItem.height; duration: 250; easing.type: Easing.InOutQuad }
                }

                ListView.onRemove: SequentialAnimation {
                    PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: true }
                    NumberAnimation { target: delegateItem; property: "height"; to: 0; duration: 250; easing.type: Easing.InOutQuad }

                    // Make sure delayRemove is set back to false so that the item can be destroyed
                    PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: false }
                }
            }

        }

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 20
            model: fruitModel
            delegate: listDelegate

            ViewItems.onDragUpdated: {
                if (event.status === ListItemDrag.Moving) {
                    model.move(event.from, event.to, 1);
                }
            }
            moveDisplaced: Transition {
                UbuntuNumberAnimation {
                    property: "y"
                }
            }
        }

        Row {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: units.gu(1)
            spacing: units.gu(1)

            Button {
                id: save
                text: "Save JSON"

                onClicked: {
                    console.log("Going to save data!")
                    var data = fruitModel;
                    console.log("model data: " + JSON.stringify(fruitModel, null, 4));

                    var res = Data.serialize(data);
                    console.log("res: " + res);
                    fileio.text = res;
                }
            }

            Button {
                id: load
                text: "Load JSON"

                onClicked: {
                    var json = JSON.parse(fileio.text);
                    console.log("count: " + json.fruits.length);

                    fruitModel.clear();
                    var count = json.fruits.length;
                    for (var i in json.fruits) {
                        var fruit = json.fruits[ i ];
                        console.log("name: " + fruit.name);
                        console.log("image: " + fruit.image );
                        console.log("description: " + fruit.description);
                        console.log("cost: " + fruit.cost);
                        fruitModel.append( fruit );
                    }

                }
            }

        }
    }
}

