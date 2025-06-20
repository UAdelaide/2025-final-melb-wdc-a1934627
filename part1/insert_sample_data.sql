
USE DogWalkService;


INSERT INTO Users (username, email, password_hash, role)
VALUES 
('alice123', 'alice@example.com', 'hashed123', 'owner'),
('bobwalker', 'bob@example.com', 'hashed456', 'walker'),
('carol123', 'carol@example.com', 'hashed789', 'owner'),
('bob', 'bobo@example.com', 'hashed666', 'walker'),
('michael', 'michale@example.com', 'hashed999', 'owner');


INSERT INTO Dogs (owner_id, name, size)
VALUES
((SELECT user_id FROM Users WHERE username = 'alice123'), 'Max', 'medium'),
((SELECT user_id FROM Users WHERE username = 'carol123'), 'Bella', 'small'),
((SELECT user_id FROM Users WHERE username = 'michael'), 'Rocky', 'large'),
((SELECT user_id FROM Users WHERE username = 'alice123'), 'Buddy', 'medium'),
((SELECT user_id FROM Users WHERE username = 'michael'), 'Luna', 'small');


INSERT INTO WalkRequests (dog_id, requested_time, duration_minutes, location, status)
VALUES
((SELECT dog_id FROM Dogs WHERE name = 'Max' AND owner_id = (SELECT user_id FROM Users WHERE username = 'alice123')), 
 '2025-06-10 08:00:00', 30, 'Boxhill', 'open'),

((SELECT dog_id FROM Dogs WHERE name = 'Bella' AND owner_id = (SELECT user_id FROM Users WHERE username = 'carol123')), 
 '2025-06-10 09:30:00', 45, 'Dockland', 'accepted'),

((SELECT dog_id FROM Dogs WHERE name = 'Rocky' AND owner_id = (SELECT user_id FROM Users WHERE username = 'michael')),
 '2025-06-11 10:00:00', 60, 'City', 'open'),

((SELECT dog_id FROM Dogs WHERE name = 'Buddy' AND owner_id = (SELECT user_id FROM Users WHERE username = 'alice123')),
 '2025-06-12 07:15:00', 20, 'Kew', 'open'),

((SELECT dog_id FROM Dogs WHERE name = 'Luna' AND owner_id = (SELECT user_id FROM Users WHERE username = 'michael')),
 '2025-06-13 18:00:00', 40, 'Doncaster', 'open');
