#include <QtCore/QLoggingCategory>
#include <QScopedPointer>
#include <QQmlContext>
#include <QGuiApplication>
#include <QQuickView>
#include <QTranslator>
#include <QLibraryInfo>
#include <QDebug>
#include "Glucometer.h"
#include "BleDiscovery.h"
#include "database/DatabaseWorker.h"
#include "database/Settings.h"
#include "database/MeasurementsListManager.h"
#include "database/Thresholds.h"
#include "database/Drugs.h"
#include "database/MealAnnotations.h"
#include "database/TextAnnotations.h"
#include "database/DrugAnnotations.h"
#include "database/Reminders.h"
#include "database/Devices.h"

#ifdef Q_OS_SAILFISH
#include <sailfishapp.h>
#else
#include <QApplication>
#include <QIcon>
#include <QQuickStyle>
#endif

void addComponent(QQuickView* view, const QString &property, QObject* component)
{
    view->rootContext()->setContextProperty(property, component);
    QObject::connect(view, SIGNAL(openglContextCreated(QOpenGLContext*)), component, SLOT(appInitialized()));
    QObject::connect(view, SIGNAL(destroyed(QObject*)), component, SLOT(deleteLater()));
}

int main(int argc, char *argv[])
{
#ifdef Q_OS_SAILFISH
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
#else
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QScopedPointer<QApplication> app(new QApplication(argc, argv));

    // enable translations
    QTranslator translator;
    translator.load(":/translations/glukometr");
    app->installTranslator(&translator);
#endif

#ifdef Q_OS_ANDROID
    QQuickStyle::setStyle("Material");
    QIcon::setThemeName("glukometr");
#endif
#ifdef Q_OS_WIN
    QQuickStyle::setStyle("Material"); //("Universal");
    QIcon::setThemeName("glukometr");
#endif
    qmlRegisterType<BleDiscovery>("glukometr", 1, 0, "BleDiscovery");
    qmlRegisterType<Glucometer>("glukometr", 1, 0, "Glucometer");
    qmlRegisterUncreatableType<SqlQueryModel>("glukometr", 1, 0, "SqlQuery", "");

    // Initialize Settings and a Worker
    DatabaseWorker* worker = new DatabaseWorker();
    QQuickView *view = new QQuickView;

    worker->start();

    // register context properties
    addComponent(view, "settings", new Settings());
    addComponent(view, "measurements", new MeasurementsListManager(worker));
    addComponent(view, "thresholds", new Thresholds(worker));
    addComponent(view, "drugs", new Drugs(worker));
    addComponent(view, "mealAnnotations", new MealAnnotations(worker));
    addComponent(view, "textAnnotations", new TextAnnotations(worker));
    addComponent(view, "drugAnnotations", new DrugAnnotations(worker));
    addComponent(view, "reminders", new Reminders(worker));
    addComponent(view, "devices", new Devices(worker));

    // load QML file and start the app
    view->setSource(QUrl("qrc:/assets/main.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->show();

    // start app
    const int retVal = app->exec();

    // quit worker thread
    worker->exit();
    worker->wait();
    delete worker;

    // return value
    return retVal;
}
