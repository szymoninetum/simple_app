from database import Base,engine
from models import Clients

print("Creating database ....")

Base.metadata.create_all(engine)