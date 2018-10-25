#include "Drugs.h"

Drugs::Drugs(
        DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent) {
    connect(this, &Drugs::tableCreated, this, &Drugs::setDefaults);
}

QString Drugs::getTableName() const {
    return "drug";
}

QString Drugs::getCreateQuery() const {
    return "CREATE TABLE drug (" \
           "drug_id integer primary key autoincrement, " \
           "name text)";
}

void Drugs::setDefaults() {
    remove();
    QStringList names = {
        "Diaprel MR", "Metformax", "Eperzan",
        "Emagliflozyna", "Starlix"
    };
    for (auto name : names)
        add(QVariantMap({{"name", name}}));
}
