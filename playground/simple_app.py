from fastapi import FastAPI, HTTPException, Depends
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

class Item(BaseModel):
  id: int
  data: str


ITEMS = []

inventory = {
  1: {
    "id_client": "4",
    "data": "abc"
  }
}


#TEST
class Client(BaseModel):
  id: int
  data: str

#good
@app.get("/health")
def get_id():
   print('hello')
   return {"hello"}

#good
@app.post("/save")
def create_client(client: Client, db: Session = Depends(get_db)):
  client_model = models.Clients()
  client_model.data = client.data

  db.add(client_model)
  db.commit()
  
  return client

@app.post("/save/{id}")
def create_client(id, client: Client, db: Session = Depends(get_db)):
  client_model = models.Clients()
  client_model.id = id
  client_model.data = client.data

  db.add(client_model)
  db.commit()
  
  print(id)
  return client


#good
@app.get("/read")
def read_api(db: Session = Depends(get_db)):
  print (models.Clients)
  return db.query(models.Clients).all()

#good
@app.get("/read/{id}")
def read_api(id, db: Session = Depends(get_db)):
  print(id)
  return db.query(models.Clients).filter(models.Clients.id == id).first()

#TEST FINISHED

  

# @app.get("/health/{id}")
# def get_id(id):
#   print(id)
#   return {"your_id": id}

#@app.post("/save")
#def post_id():



# @app.post("/save/{id}")
# def post_id(id: int, item: Item):
#   if id in inventory:
#     return{"Error": "Client ID already exists"}

#   inventory[id] = {"data": item.data}
#   return inventory[id] 


#@app.get("read")

#@app.get("read/{id}")
