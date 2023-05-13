CREATE TABLE member (
    membership_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    date_of_birth DATE,
    mobile_no VARCHAR(20)
);

CREATE TABLE inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(255),
    manufacturer_name VARCHAR(255),
    cost NUMERIC(10, 2),
    weight_kg NUMERIC(10, 2)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    membership_id INT,
    total_items_price NUMERIC(10, 2),
    total_items_weight NUMERIC(10, 2),
    FOREIGN KEY (membership_id) REFERENCES member(membership_id)
);

CREATE TABLE transaction_items (
    transaction_id INT,
    item_id INT,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (item_id) REFERENCES inventory(item_id)
);

-- Insert into member
INSERT INTO member (membership_id, name, email, date_of_birth, mobile_no) 
VALUES 
('smithb51a3', 'Patty Smith', 'Patty_Smith@ross.com', '1975-08-27', '59428759'),
('wang15e50', 'Sean Wang DDS', 'Sean_Wang@gibson-calderon.com', '1960-11-03', '25595367'),
('estrada1346b', 'Richard Estrada', 'Richard_Estrada@malone.com', '1992-10-15', '22821527'),
('clinef29ff', 'Jackson Cline', 'Jackson_Cline@hudson.net', '1971-01-21', '48056519'),
('williamsbf104', 'Allen Williams', 'Allen_Williams@sanchez.net', '1997-09-11', '77991519');

-- Insert into inventory
INSERT INTO inventory (item_id, item_name, manufacturer_name, cost, weight_kg) 
VALUES 
(1, 'Item 1', 'Manufacturer A', 100.00, 5.00),
(2, 'Item 2', 'Manufacturer B', 200.00, 10.00);

-- Insert into transactions
INSERT INTO transactions (transaction_id, membership_id, total_items_price, total_items_weight) 
VALUES 
(1, 'smithb51a3', 100.00, 5.00),
(2, 'smithb51a3', 200.00, 10.00),
(3, 'wang15e50', 300.00, 15.00),
(4, 'estrada1346b', 300.00, 15.00),
(5, 'estrada1346b', 500.00, 25.00);

-- Insert into transaction_items
INSERT INTO transaction_items (transaction_id, item_id) 
VALUES 
(1, 1),
(2, 2),
(3, 1),
(3, 2),
(4, 1),
(4, 1),
(4, 1),
(5, 1),
(5, 2),
(5, 2);


