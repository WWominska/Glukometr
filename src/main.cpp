#include <QtCore/QLoggingCategory>
#include <QScopedPointer>
#include <QQmlContext>
#include <QGuiApplication>
#include <QQuickView>
#include <QDebug>
#include "Glucometer.h"
#include "BleDiscovery.h"
#include "database/DatabaseWorker.h"
#include "database/Settings.h"
#include "database/MeasurementsListManager.h"

#ifdef Q_OS_SAILFISH
#include <sailfishapp.h>
#else
#include <QQuickStyle>
#endif

int main(int argc, char *argv[])
{
#ifdef Q_OS_SAILFISH
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
#else
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));
#endif

#ifdef Q_OS_ANDROID
    QQuickStyle::setStyle("Material");
#endif
#ifdef Q_OS_WIN
    QQuickStyle::setStyle("Universal");
#endif
    qmlRegisterType<BleDiscovery>("glukometr", 1, 0, "BleDiscovery");
    qmlRegisterType<Glucometer>("glukometr", 1, 0, "Glucometer");
    qmlRegisterUncreatableType<SqlQueryModel>("glukometr", 1, 0, "SqlQuery", "");

    // Initialize Settings and a Worker
    Settings* settings = new Settings();
    DatabaseWorker* worker = new DatabaseWorker();
    QQuickView *view = new QQuickView;

    worker->start();

    // Initialize and register managers
    MeasurementsListManager *measurements = new MeasurementsListManager(worker);

    // register context properties
    view->rootContext()->setContextProperty("appSettings", settings);
    view->rootContext()->setContextProperty("measurements", measurements);

    // load QML file and start the app
    view->setSource(QUrl("qrc:/assets/main.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->show();

    // start app
    const int retVal = app->exec();

    // quit worker thread
    worker->exit();
    worker->wait();

    // delete everything
    delete measurements;
    delete settings;
    delete worker;

    // return value
    return retVal;
}
