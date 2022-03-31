from fastapi import FastAPI
 
app = FastAPI()
 
@app.get("/")
def root():
  return {"message": "Hello World!"}

@app.get("/messi")
def messi():
  return {"messi": "Hello!"}

