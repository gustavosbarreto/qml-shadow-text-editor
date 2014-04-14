#include <QApplication>
#include <QInputDialog>
#include <QUdpSocket>
#include <QDebug>

#include "qmlapplicationviewer.h"
#include "qhttpserver.h"
#include "qhttprequest.h"
#include "qhttpresponse.h"

class SessionServer: public QObject
{
	Q_OBJECT

public:
	QString name;

	SessionServer(): QObject()
	{
		udp = new QUdpSocket(this);
        udp->bind(1903, QUdpSocket::ShareAddress);
		
		connect(udp, SIGNAL(readyRead()), SLOT(processPendingDatagrams()));
	}

public Q_SLOTS:
	void handle(QHttpRequest *req, QHttpResponse *res)
	{
		if (req->method() == QHttpRequest::HTTP_POST)
		{
			connect(req, SIGNAL(end()), SLOT(readBody()));
			connect(req, SIGNAL(end()), res, SLOT(end()));
			
			req->storeBody();
			res->writeHead(200);
		}
		else
		{
			res->writeHead(200);
			res->write(text.toUtf8());
			res->end();
		}
	}
	
	void readBody()
	{
        QHttpRequest *req = (QHttpRequest *)QObject::sender();
        if (req->successful())
            text = req->body();
	}
	
	void processPendingDatagrams()
	{
		while (udp->hasPendingDatagrams())
		{
			QByteArray datagram;
		    datagram.resize(udp->pendingDatagramSize());
		    udp->readDatagram(datagram.data(), datagram.size());

			datagram.clear();
		    datagram = name.toUtf8();
		    udp->writeDatagram(datagram.data(), datagram.size(), QHostAddress::Broadcast, 1983);
		}
	}

private:
	QString text;
	QUdpSocket *udp;
};

int main(int argc, char *argv[])
{
	QApplication app(argc, argv);

	SessionServer *session = new SessionServer;
	
	do
	{
		session->name = QInputDialog::getText(NULL, QObject::trUtf8("Digite um nome para esta sessão"),
			QObject::trUtf8("Este nome será utilizado para identificar esta sessão na rede."));
	} while (session->name.isEmpty());
	
    QmlApplicationViewer viewer;
    viewer.addImportPath(QLatin1String("modules"));
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile("qrc:/main.qml");
    viewer.showExpanded();
	viewer.setWindowTitle("Editor do Professor - " + session->name);
	
	QHttpServer *server = new QHttpServer;
	QObject::connect(server, SIGNAL(newRequest(QHttpRequest *, QHttpResponse *)),
	        session, SLOT(handle(QHttpRequest *, QHttpResponse *)));

	server->listen(1995);

	return app.exec();
}

#include "main.moc"
