import database
from db import Row
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/display_service', methods=['GET'])
def display_service():
    
    total_sum: float = database.get_sum_of_all_values()
    rows: list[Row] = database.get_all_rows()
    
    return render_template('display_service.html', total_sum=total_sum, rows=rows)

if __name__ == "__main__":
    app.run()