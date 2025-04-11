from flask import Flask, request, render_template_string
import mysql.connector

app = Flask(__name__)


DB_CONFIG = {
    'user': 'fccuser',
    'password': 'fccuser',
    'host': 'localhost',
    'database': 'fcc',
}

HTML_TEMPLATE = """
<!doctype html>
<html>
<head>
    <title>Ham Radio Lookup</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minimal Page</title>
    <style>
        table {
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 4px;
        }
    </style>
</head>
<body>
    <h1>Ham Radio License Lookup</h1>
    <form method="get">
        <label>Call Sign: <input type="text" name="call_sign" value="{{ params.call_sign if (params.call_sign is defined and params.call_sign is not none) else '' }}"></label><br>
        <label>First Name: <input type="text" name="first_name" value="{{ params.first_name if (params.first_name is defined and params.first_name is not none) else '' }}"></label><br>
        <label>Last Name: <input type="text" name="last_name" value="{{ params.last_name if (params.last_name is defined and params.last_name is not none) else '' }}"></label><br>
        <label>City: <input type="text" name="city" value="{{ params.city if (params.city is defined and params.city is not none) else '' }}"></label><br>
        <label>State: <input type="text" name="state" value="{{ params.state if (params.state is defined and params.state is not none) else '' }}"></label><br>

        <p>License Status:</p>
        {% for status in ['A', 'C', 'E', 'L', 'P', 'T', 'X'] %}
            <label><input type="checkbox" name="license_status" value="{{ status }}" {% if status in request.args.getlist('license_status') or (not request.args and status == 'A') %}checked{% endif %}> {{ status }}</label>
        {% endfor %}
        <br>

        <p>Operator Class:</p>
        {% for op_class in ['A', 'E', 'G', 'N', 'P', 'T'] %}
            <label><input type="checkbox" name="operator_class" value="{{ op_class }}" {% if op_class in request.args.getlist('operator_class') or (not request.args and op_class in ['T', 'G', 'E']) %}checked{% endif %}> {{ op_class }}</label>
        {% endfor %}
        <br>

        <input type="submit" value="Search">
    </form>

    {% if results %}
        <h2>Results</h2>
        <table>
            <tr><th>Call Sign</th><th>License Status</th><th>Operator Class</th><th>Region Code</th><th>First Name</th><th>Last Name</th><th>City</th><th>State</th></tr>
            {% for row in results %}
                <tr>
                    <td>{{ row['call_sign'] }}</td>
                    <td>{{ row['license_status'] }}</td>
                    <td>{{ row['operator_class'] }}</td>
                    <td>{{ row['region_code'] }}</td>
                    <td>{{ row['first_name'].title() }}</td>
                    <td>{{ row['last_name'].title() }}</td>
                    <td>{{ row['city'].title() }}</td>
                    <td>{{ row['state'] }}</td>
                </tr>
            {% endfor %}
        </table>
    {% endif %}
</body>
</html>
"""

@app.route('/', methods=['GET'])
def index():
    query_params = {
        'call_sign': request.args.get('call_sign'),
        'first_name': request.args.get('first_name'),
        'last_name': request.args.get('last_name'),
        'city': request.args.get('city'),
        'state': request.args.get('state'),
        'license_status': request.args.getlist('license_status') or (['A'] if not request.args else []),
        'operator_class': request.args.getlist('operator_class') or (['T', 'G', 'E'] if not request.args else []),
    }

    query = """
        SELECT en.call_sign, hd.license_status, am.operator_class,
               am.region_code, en.first_name, en.last_name,
               en.city, en.state
        FROM en
        JOIN hd ON hd.sys_id = en.sys_id
        JOIN am ON am.sys_id = en.sys_id
        WHERE 1=1
    """
    
    params = []

    if query_params['call_sign'] or query_params['first_name'] or query_params['last_name'] or query_params['city'] or query_params['state']:
        if query_params['call_sign']:
            query += " AND en.call_sign = %s"
            params.append(query_params['call_sign'].upper().strip())
        if query_params['first_name']:
            query += " AND en.first_name LIKE %s"
            params.append(f"{query_params['first_name'].strip()}%")
        if query_params['last_name']:
            query += " AND en.last_name LIKE %s"
            params.append(f"{query_params['last_name'].strip()}%")
        if query_params['city']:
            query += " AND en.city LIKE %s"
            params.append(f"{query_params['city'].strip()}%")
        if query_params['state']:
            query += " AND en.state = %s"
            params.append(query_params['state'].strip().upper())
        if query_params['license_status']:
            placeholders = ','.join(['%s'] * len(query_params['license_status']))
            query += f" AND hd.license_status IN ({placeholders})"
            params.extend([s.upper() for s in query_params['license_status']])
        if query_params['operator_class']:
            placeholders = ','.join(['%s'] * len(query_params['operator_class']))
            query += f" AND am.operator_class IN ({placeholders})"
            params.extend([c.upper() for c in query_params['operator_class']])

        query += " ORDER BY en.last_name ASC, en.first_name ASC"
        
        try:
            conn = mysql.connector.connect(**DB_CONFIG)
            cur = conn.cursor(dictionary=True)
            cur.execute(query, params)
            results = cur.fetchall()
        except mysql.connector.Error as err:
            print("Database error:", err)
            results = []
        finally:
            cur.close()
            conn.close()
    else:
        results = []
            
    return render_template_string(HTML_TEMPLATE, params=query_params, results=results)

if __name__ == '__main__':
    app.run(debug=True)
