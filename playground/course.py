from fastapi import FastAPI
 
app = FastAPI()


@app.get("/courses/{course_name}")
def read_course(course_name):
  print(course_name)
  #zapis do SQLite
  
  return {"course_name": course_name}