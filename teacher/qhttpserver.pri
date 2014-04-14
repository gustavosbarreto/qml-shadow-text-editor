INCLUDEPATH += $$PWD/qhttpserver/http-parser $$PWD/qhttpserver/src

QT += network

SOURCES += qhttpserver/src/*.cpp $$PWD/qhttpserver/http-parser/http_parser.c
HEADERS += qhttpserver/src/*.h $$PWD/qhttpserver/http-parser/http_parser.h
