from fastapi import FastAPI
 
app = FastAPI()
 
course_items = [{"course_name": "Python"}, {"course_name": "SQLAlchemy"}, {"course_name": "NodeJS"}]
 
@app.get("/courses/")
def read_courses(start: int, end: int):
    return course_items[start : start + end]