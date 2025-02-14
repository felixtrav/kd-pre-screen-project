import database
from db import Row
from flask import Flask, render_template, jsonify


app = Flask(__name__)

@app.route('/reset_service', methods=['GET'])
def reset_service():
    
    total_sum: float = database.get_sum_of_all_values()
    rows: list[Row] = database.get_all_rows()
    
    return render_template('reset_service.html', total_sum=total_sum, rows=rows)

@app.route('/reset_table', methods=['POST'])
def reset_table():
    
    database.reset_table()

    return jsonify({'success': True}), 200

if __name__ == "__main__":
    app.run()