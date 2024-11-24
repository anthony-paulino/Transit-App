INSERT INTO questionpost (questionID, question, customerID, customerName, username, datePosted, status) VALUES
(1, 'What time is the train from Woodbridge?', 1, NULL, NULL, '2024-11-21 21:33:15', NULL),
(2, 'How much is a child ticket?', 1, NULL, NULL, '2024-11-21 21:33:26', NULL),
(3, 'How much is an adult ticket?', 3, NULL, NULL, '2024-11-21 21:34:22', NULL),
(4, 'Can I change my reservation date?', 4, NULL, NULL, '2024-11-21 21:36:26', NULL),
(5, 'Can I change my password to 1234?', 4, NULL, NULL, '2024-11-21 21:37:07', NULL),
(6, 'Can I change my username to Jane Smith?', 2, NULL, NULL, '2024-11-21 21:37:37', null);

INSERT INTO commentreply (commentID, comment, customerID, employeeID, datePosted) VALUES
(1, 'Yes', NULL, 2, '2024-11-21 22:57:17'),
(2, 'Yes', NULL, 2, '2024-11-21 22:57:33'),
(3, '5', NULL, 2, '2024-11-21 22:57:47'),
(4, 'yes', NULL, 3, '2024-11-21 22:58:23'),
(5, 'great', NULL, 3, '2024-11-21 22:58:29'),
(6, 'really', NULL, 3, '2024-11-21 22:58:47');
