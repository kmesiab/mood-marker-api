from flask import Flask

from nouns import nouns
from ner import ner
from sentiment import sentiment

app = Flask(__name__)

app.register_blueprint(ner)
app.register_blueprint(sentiment)
app.register_blueprint(nouns)

if __name__ == "__main__":
    app.run()
