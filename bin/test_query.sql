use fcc;

SELECT en.call_sign,
       hd.license_status,
       am.operator_class,
       am.region_code,
       en.first_name,
       en.last_name
FROM en
     JOIN hd ON hd.sys_id = en.sys_id
     JOIN am ON am.sys_id = en.sys_id
WHERE en.call_sign in ("W7DNS", "KE7HT", "W6EPW", "KJ7MNO", "N7LRW", "KJ7ZMZ")
      AND license_status = "A"
      ORDER BY en.last_name ASC, en.first_name ASC
;