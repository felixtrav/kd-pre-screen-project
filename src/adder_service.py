import database
from flask import Flask, render_template, request, jsonify


app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

@app.route('/adder_service', methods=['GET'])
def adder_service():
    total_sum: float = database.get_sum_of_all_values()
    return render_template('adder_service.html', total_sum=total_sum)

@app.route('/add_number', methods=['POST'])
def add_number():
    
    try:
        data = request.get_json()
        value = float(data['number'])
        ip_address = data['ip_address']
        
        database.add_value_entry(value, ip_address)
        return jsonify({'success': True}), 200
    
    except (KeyError, ValueError) as e:
        return jsonify({'error': str(e)}), 400

if __name__ == "__main__":
    app.run()