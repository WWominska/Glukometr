#include "Reminders.h"

Reminders::Reminders(
        DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent) {
    connect(
        this, &Reminders::modelChanged,
        this, &Reminders::clearExpiredReminders);
}

QString Reminders::getTableName() const {
    return "reminder";
}

QString Reminders::getCreateQuery() const {
    return "CREATE TABLE IF NOT EXISTS reminder (" \
           "reminder_id integer primary key autoincrement, " \
           "reminder_datetime text NOT NULL, " \
           "cookie_id integer, " \
           "repeating integer, " \
           "reminder_type integer DEFAULT 0)";
}


void Reminders::cancel(int cookie) {
    callTimedClient(QStringList() << QString("-c%1").arg(cookie));
}

void Reminders::cancelInvalidEvents() {
    QStringList result = callTimedClient(QStringList(
                                             "-s\"APPLICATION=glukometr\""));
    QStringList cookies = result[0].split(" ");
    cookies.removeAll(QString(""));

    // make a list of valid cookies
    QStringList validCookies;
    for (int i = 0; i < this->m_model->rowCount(); i++)
        validCookies.append(m_model->record(i).value("cookie_id").toString());

    // check which are invalid and cancel them
    for (QString cookie: cookies)
        if (!validCookies.contains(cookie))
            cancel(cookie.toInt());

    // clean invalid entries from DB
    for (QString cookie: validCookies)
        if (!cookies.contains(cookie))
            remove({{"cookie_id", cookie.toInt()}});
}

void Reminders::clearExpiredReminders() {
    QString query = QString("DELETE FROM %1 WHERE reminder_datetime < :date "
                            "AND repeating = 0").arg(getTableName());

    this->executeQuery(
                query, [=](QSqlQuery) {cancelInvalidEvents();},
                QVariantMap({
                    {"date", QDateTime::currentDateTime().toTime_t()}
                }));
}

void Reminders::remind(
            QString title, int reminderType, QDateTime when, bool repeating)
{
    // format time of day
    int timeOfDay = when.time().hour() * 60 + when.time().minute();

    // prepare arguments
    QStringList args;
    if (repeating)
    {
        args << QString("-r\"hour=%1;minute=%2;%3\"").arg(
            QString::number(when.time().hour()),
            QString::number(when.time().minute()),
            "everyDayOfWeek;everyDayOfMonth;everyMonth"
        );
    }

    args << "-b\"TITLE=button0\"";
    QString eventArg = QString(
                "-e\"APPLICATION=%1;TITLE=%2;type=event;timeOfDay=%3").arg(
                "glukometr", title, QString::number(timeOfDay));
    if (!repeating) {
        QString timeArg = when.toString("yyyy-MM-dd HH:mm:ss");
        eventArg += QString(";time=%1").arg(timeArg);
    }

    args << eventArg + "\"";
    QStringList result = callTimedClient(args);

    if (!result[0].isEmpty() && result[1].isEmpty()) {
        int cookie = result[0].split(" ").last().toInt();
        add(QVariantMap({
            {"cookie_id", cookie},
            {"reminder_type", reminderType},
            {"repeating", int(repeating)},
            {"reminder_datetime", when.toTime_t()},
        }));
    }
}

void Reminders::remind(
            QString title, int reminderType, bool repeating)
{
    // if date and time not provided, use current one
    remind(title, reminderType, QDateTime::currentDateTime(), repeating);
}

void Reminders::remindInTwoHours()
{
    // fix: don't hardcode strings, maybe move back to QML
    QDateTime twoHoursLater = QDateTime::currentDateTime().addSecs(60*60*2);
    remind("Zmierz cukier", 0, twoHoursLater, 0);
}

QStringList Reminders::callTimedClient(const QStringList &args)
{
    // TODO: replace calling timedClient with calling DBus directly
    // this allows dropping timedclient as dependency
    QProcess timedClient;
    timedClient.start("timedclient-qt5 " + args.join(" "));
    timedClient.waitForFinished();
    QStringList output;
    output << timedClient.readAll().trimmed() << timedClient.readAllStandardError().trimmed();
    return output;
}
