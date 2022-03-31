from fastapi import FastAPI
import models
from sqlalchemy.orm import Session
from database import SessionLocal, engine
from pydantic import BaseModel

app = FastAPI()
models.Base.metadata.create_all(bind=engine)

class StockRequest(BaseModel):
    symbol:str


@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: str =None):
    return {"item_id": item_id, "q": q}

@app.post{"/stock"}
def create_stock(stock_request: StockRequest):
    return{
        "code": "success",
        "message": "welcome on stock market"
    }
