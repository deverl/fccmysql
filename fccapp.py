from flask import Flask, request, render_template
from user_agents import parse
import mysql.connector

app = Flask(__name__)


DB_CONFIG = {
    'user': 'fccuser',
    'password': 'fccuser',
    'host': 'localhost',
    'database': 'fcc',
}


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
        'title_case': request.args.get('title_case') == '1',
    }


    user_agent = request.headers.get('User-Agent')
    ua = parse(user_agent)

    template = "desktop.html"

    if ua.is_mobile:
        template = "mobile.html"

    query = """
        SELECT en.call_sign, hd.license_status, am.operator_class, en.frn,
               am.region_code,
               if(dmr.radio_id is not null, dmr.radio_id, "") as dmr_id,
               en.first_name, en.last_name,
               en.street_address, en.city, en.state
        FROM en
        JOIN hd ON hd.sys_id = en.sys_id
        JOIN am ON am.sys_id = en.sys_id
        LEFT JOIN dmr on dmr.call_sign = en.call_sign
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
        template = "empty.html"

    return render_template(template, params=query_params, results=results)

if __name__ == '__main__':
    app.run(debug=True)
