import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("POSTGRES_DB_URL", "")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
