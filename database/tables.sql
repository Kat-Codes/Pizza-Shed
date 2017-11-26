TABLES FOR ACCOUNTS.SQLITE


CREATE TABLE users(
    userID INTEGER NOT NULL UNIQUE,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    firstName TEXT NOT NULL,
    surname TEXT NOT NULL,
    accountType INTEGER NOT NULL,
    email TEXT NOT NULL UNIQUE,
    PRIMARY KEY(userID)
);

INSERT INTO users VALUES(1, "lawrence1", "password", "lawrence", "schobs", 0, "laschobs1@sheffield.ac.uk");
INSERT INTO users VALUES(2, "georgina1", "password", "georgina", "lea", 0, "gealea1@sheffield.ac.uk");

CREATE TABLE customer(
    userID INTEGER NOT NULL UNIQUE,
    twitterHandle TEXT NOT NULL UNIQUE,
    addressLine1 TEXT NOT NULL,
    adressLine2 TEXT,
    postCode TEXT NOT NULL,
    city TEXT NOT NULL,
    PRIMARY KEY(userID)
);

CREATE TABLE admins(
    userID INTEGER NOT NULL UNIQUE,
    orderLondonPriviledge INTEGER NOT NULL,
    orderSheffieldPriviledge INTEGER NOT NULL,
    accountsPiviledge INTEGER NOT NULL,
    menuPriviledge INTEGER NOT NULL,
    marketingPriviledge INTEGER NOT NULL   
);

INSERT into admins VALUES(6, 1, 1, 1, 1, 1);

INSERT INTO customer VALUES(1, "LawrenceSchobs", "Flat 21 BroadLane Court", "", "S1 4BU", "sheffield");
INSERT INTO customer VALUES(2, "geegeelea", "12 St Georges Close", null, "S3 7HD", "sheffield");


TABLES FOR MENU.SQLITE

CREATE TABLE newMenu(
    id INTEGER NOT NULL UNIQUE,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    description TEXT NOT NULL,
    imageURL TEXT
);

INSERT INTO newMenu VALUES(1, "Margherita", 6.99, "Cheese, Tomato Sauce", "http://www.pizzagogo.co.uk/static/media/products/large/14.jpg");


TABLES FOR ORDERS.SQLITE

CREATE TABLE orders(
    orderID INTEGER NOT NULL UNIQUE,
    tweetID INTEGER NOT NULL UNIQUE,
    userID INTEGER NOT NULL,
    orderDesc TEXT NOT NULL,
    orderStatus INTEGER NOT NULL,
    orderOffer TEXT
);

CREATE TABLE questions(
    questionID INTEGER NOT NULL UNIQUE,
    tweetID INTEGER NOT NULL UNIQUE,
    userID INTEGER NOT NULL,
    questionTEXT NOT NULL,
    questionStatus INTEGER NOT NULL
);

INSERT INTO orders VALUES(4, 23, "Gimme a Pepperoni with extra cheese please", 1, null);

INSERT INTO questions VALUES(1, 23, "How much for a Margherita with olives", 1)


