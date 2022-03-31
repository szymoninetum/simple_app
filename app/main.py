from typing import TYPE_CHECKING, List
import fastapi as _fastapi
import sqlalchemy.orm as _orm

import schemas as _schemas
import services as _services

if TYPE_CHECKING:
    from sqlalchemy.orm import Session

app = _fastapi.FastAPI()


@app.post("/doc/{contact_id}/", response_model=_schemas.Contact)
async def create_contact(
    contact: _schemas.CreateContact,
    db: _orm.Session = _fastapi.Depends(_services.get_db),
):
    return await _services.create_contact(contact=contact, db=db)


@app.get("/doc/", response_model=List[_schemas.Contact])
async def get_contacts(db: _orm.Session = _fastapi.Depends(_services.get_db)):
    return await _services.get_all_contacts(db=db)


@app.get("/doc/{contact_id}/", response_model=_schemas.Contact)
async def get_contact(
    contact_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)
):
    contact = await _services.get_contact(db=db, contact_id=contact_id)
    if contact is None:
        raise _fastapi.HTTPException(status_code=404, detail="Contact does not exist")

    return contact


@app.delete("/doc/{contact_id}/")
async def delete_contact(
    contact_id: int, db: _orm.Session = _fastapi.Depends(_services.get_db)
):
    contact = await _services.get_contact(db=db, contact_id=contact_id)
    if contact is None:
        raise _fastapi.HTTPException(status_code=404, detail="Contact does not exist")

    await _services.delete_contact(contact, db=db)

    return "successfully deleted the user"