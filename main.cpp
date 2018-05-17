#include <QtCore/QLoggingCategory>
#include <QScopedPointer>
#include <QQmlContext>
#include <QGuiApplication>
#include <QQuickView>
#include "Glucometer.h"
#include "BleDiscovery.h"

#ifdef Q_OS_SAILFISH
#include <sailfishapp.h>
#endif

int main(int argc, char *argv[])
{
#ifdef Q_OS_SAILFISH
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
#else
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));
#endif

    qmlRegisterType<BleDiscovery>("glukometr", 1, 0, "BleDiscovery");
    qmlRegisterType<Glucometer>("glukometr", 1, 0, "Glucometer");

    QQuickView *view = new QQuickView;
    view->setSource(QUrl("qrc:/assets/main.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->show();
    return app->exec();
}
