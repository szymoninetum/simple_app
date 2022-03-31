import datetime as _dt
import sqlalchemy as _sql

import database as _database


class Contact(_database.Base):
    __tablename__ = "contacts"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    data = _sql.Column(_sql.String, index=True)
