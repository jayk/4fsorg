CREATE TABLE forms (id INTEGER PRIMARY KEY, owner NUMERIC, formkey TEXT, form BLOB);
CREATE TABLE pastes (views NUMERIC, last_view_time NUMERIC, create_time NUMERIC, owner NUMERIC, pastekey TEXT, content BLOB, parent TEXT);
CREATE TABLE users (id INTEGER PRIMARY KEY, password TEXT, email TEXT);
