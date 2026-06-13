from dotenv import load_dotenv
load_dotenv()
import os
from src.app import create_app

PORT = int(os.getenv("PORT", "8082"))
app = create_app()

if __name__=='__main__':
    app.run(host='0.0.0.0', port=PORT, debug=True) 