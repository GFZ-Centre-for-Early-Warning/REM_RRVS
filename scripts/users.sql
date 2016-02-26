--add test users, roles and tasks
INSERT INTO users.users(id, authenticated, name) VALUES (1, TRUE, 'Kerak engineer');
INSERT INTO users.users(id, authenticated, name) VALUES (2, TRUE, 'Madaba engineer');

INSERT INTO users.roles(id, name) VALUES (1, 'public');
INSERT INTO users.roles_users(user_id, role_id) VALUES (1, 1);
INSERT INTO users.roles_users(user_id, role_id) VALUES (2, 1);
