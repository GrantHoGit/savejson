TEMPLATE = aux
TARGET = savejson

RESOURCES += savejson.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true) \
             $$files(pics/*.*, true)

CONF_FILES +=  savejson.apparmor \
               savejson.desktop \
               savejson.png

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
    savedata.js

#specify where the qml/js files are installed to
qml_files.path = /savejson
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /savejson
config_files.files += $${CONF_FILES}

INSTALLS+=config_files qml_files

