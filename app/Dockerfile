FROM python:3.10-alpine

WORKDIR /usr/app
COPY . .
RUN pip install -r requirements.txt
CMD [ "uvicorn", "main:app"]

EXPOSE 8000


   