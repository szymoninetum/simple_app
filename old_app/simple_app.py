from fastapi import FastAPI, HTTPException, Depends, status
from pydantic import BaseModel
import models
from uuid import UUID
from database import engine, SessionLocal
from sqlalchemy.orm import Session

app = FastAPI()

models.Base.metadata.create_all(bind=engine)

def get_db():
  try:
    db = SessionLocal()
    yield db
  finally:
    db.close()

#class Item(BaseModel):
  # id: int
  # data: str


# ITEMS = []

# inventory = {
#   1: {
#     "id_client": "4",
#     "data": "abc"
#   }
# }

db=SessionLocal()

#TEST
class Client(BaseModel):
  data: str

  class Config:
        orm_mode=True

#good
@app.get("/health", response_model=Client, status_code=200)
def get_id():
   print('hello')
   return {"hello"}

#good
@app.post("/doc", response_model=Client, status_code=200)
def create_client(client: Client, db: Session = Depends(get_db)):
  client_model = models.Clients()
  client_model.data = client.data

  db.add(client_model)
  db.commit()
  
  return client

@app.post("/doc/{id}", response_model=Client, status_code=200)
def create_client(id, client: Client, db: Session = Depends(get_db)):
  client_model = models.Clients()
  client_model.id = id
  client_model.data = client.data
  db.add(client_model)
  db.commit()
  
  print(id)
  return client


#good
@app.get("/doc", response_model=Client, status_code=200)
def read_api(db: Session = Depends(get_db)):
  print (models.Clients)
  return db.query(models.Clients).all()

#good
@app.get("/doc/{id}", response_model=Client, status_code=200)
def read_api(id, db: Session = Depends(get_db)):
  print(id)
  return db.query(models.Clients).filter(models.Clients.id == id).first()


@app.delete("/doc/{id}", response_model=Client, status_code=200)
def delete_client(id, db: Session = Depends(get_db)):
  client_model = db.query(models.Clients).filter(models.Clients.id == id).first()

  if client_model is None:
    raise HTTPException(
      status_code=404,
      detail=f"ID {id} : does not exist"
    )
  
  db.query(models.Clients).filter(models.Clients.id == id).delete()

  db.commit()

  print(id +" was deleted")

#TEST FINISHED

