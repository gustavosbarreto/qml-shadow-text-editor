#include <QApplication>
#include <QDeclarativeContext>
#include <QInputDialog>
#include <QUdpSocket>
#include <QDebug>
#include <QHostInfo>

#include "qmlapplicationviewer.h"

class SessionDiscover: public QObject
{
	Q_OBJECT

public:
	SessionDiscover(): QObject()
	{
		udp = new QUdpSocket(this);
        udp->bind(1983, QUdpSocket::ShareAddress);

		connect(udp, SIGNAL(readyRead()), SLOT(processPendingDatagrams()));
	}

public Q_SLOTS:
	void sendDiscover()
	{
		QByteArray datagram = "...";
		udp->writeDatagram(datagram.data(), datagram.size(), QHostAddress::Broadcast, 1903);
	}

	void processPendingDatagrams()
	{
		while (udp->hasPendingDatagrams())
		{
			QByteArray datagram;
		    QHostAddress sender;
		    quint16 senderPort;

		    datagram.resize(udp->pendingDatagramSize());
		    udp->readDatagram(datagram.data(), datagram.size(), &sender, &senderPort);

			emit newSession(QString::fromUtf8(datagram), QHostAddress(sender.toIPv4Address()).toString());
		}
	}

signals:
	void newSession(const QString &name, const QString &address);

private:
	QUdpSocket *udp;
};

int main(int argc, char *argv[])
{
	QApplication app(argc, argv);

	SessionDiscover *session = new SessionDiscover;

    QmlApplicationViewer viewer;
	viewer.rootContext()->setContextProperty("session", session);
    viewer.addImportPath(QLatin1String("modules"));
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile("qrc:/main.qml");
    viewer.showExpanded();
	viewer.setWindowTitle("Editor do Aluno");

	return app.exec();
}

#include "main.moc"
