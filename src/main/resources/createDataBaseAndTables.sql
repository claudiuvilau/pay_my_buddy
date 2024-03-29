SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS payMyBuddy CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE payMyBuddy;

CREATE TABLE IF NOT EXISTS Roles (
    id_roles INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_role VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_roles),
	UNIQUE INDEX ind_name_roles (name_role)
)
ENGINE=INNODB;

INSERT INTO Roles (id_roles, name_role) VALUES 
	(1, "ADMIN"),
	(2, "USER");


CREATE TABLE IF NOT EXISTS Users (
	id_users INT UNSIGNED NOT NULL AUTO_INCREMENT,
	id_email VARCHAR(50) NOT NULL,
	name_user VARCHAR(20) NOT NULL,
	first_name VARCHAR(40) NOT NULL,
	birth_date DATE NOT NULL,
	password CHAR(60) NOT NULL, 
	role_id INT UNSIGNED NOT NULL,
	PRIMARY KEY (id_users),
	CONSTRAINT fk_role_id 
		FOREIGN KEY (role_id) 
		REFERENCES Roles(id_roles),
	UNIQUE INDEX ind_id_email (id_email), 
	UNIQUE INDEX ind_password (password)
)
ENGINE=INNODB;

INSERT INTO Users (id_users, id_email, name_user, first_name, birth_date, password, role_id) VALUES 
	(1, "jack.dupont@yahoo.fr", "DUPONT", "Jack", "1982-01-22", "$2a$10$L17796jDsldbIAteOItmZONsqtcHYBBOO8YMiIZ8zQ8TpqkkI6YBm", 2),
	(2, "mireille.benoit@hotmail.com", "BENOIT", "Mireille", "1970-12-31", "$2a$10$f0kDO5HMomT0zjdC7YwSF.gBnof2mNe94E6TGfCERPByrFHxiluUy", 1),
	(3, "sebastien.martin@hotmail.fr", "MARTIN", "Sébastien", "1977-09-19", "$2a$10$IAzJLgE0gtud70R3L4cjiuTT8OmKZg7l.QKQxz3phUZWUu9BXfi1S", 2);


CREATE TABLE IF NOT EXISTS Friends (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	users_id_users INT UNSIGNED NOT NULL,
	buddy INT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT fk_user_id_users_Friends 
		FOREIGN KEY (users_id_users) 
		REFERENCES Users(id_users),
	CONSTRAINT fk_buddy_Friends  
		FOREIGN KEY (buddy) 
		REFERENCES Users(id_users),
	UNIQUE INDEX UQ_ind_users_id_users_buddy (users_id_users, buddy)
)
ENGINE=INNODB;

INSERT INTO Friends (users_id_users, buddy) VALUES 
	(1, 2),
	(1, 3),
	(3, 2);

CREATE TABLE IF NOT EXISTS CollectionMoney (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	start_date DATE UNIQUE NOT NULL,
	end_date DATE UNIQUE NOT NULL,
	amount_percentage DECIMAL(5,3) NOT NULL,
	PRIMARY KEY (id)
)
ENGINE=INNODB;

INSERT INTO CollectionMoney (start_date, end_date, amount_percentage) VALUES 
	("2022-12-01", "2099-12-31", 0.005);

CREATE TABLE IF NOT EXISTS Transactions (
	id_trans INT UNSIGNED NOT NULL AUTO_INCREMENT,
	date_trans DATE NOT NULL,
	user INT UNSIGNED NOT NULL,
	invoiced CHAR(1) NOT NULL DEFAULT '0',
	PRIMARY KEY (id_trans),
	CONSTRAINT fk_user_id_users_Transactions 
		FOREIGN KEY (user) 
		REFERENCES Users(id_users)
)
ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS TypeTransactions (
	id_type_trans INT UNSIGNED NOT NULL AUTO_INCREMENT,
	nom_type_trans VARCHAR(15) NOT NULL,
	PRIMARY KEY (id_type_trans)
)
ENGINE=INNODB;

INSERT INTO TypeTransactions (id_type_trans, nom_type_trans) VALUES 
	(1, "CREDIT"),
	(2, "DEBIT");


CREATE TABLE IF NOT EXISTS NameTransactions (
	id_name_trans INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name_trans VARCHAR(15) NOT NULL,
	type_name_trans INT UNSIGNED NOT NULL,
	PRIMARY KEY (id_name_trans),
	CONSTRAINT fk_type_name_trans 
		FOREIGN KEY (type_name_trans) 
		REFERENCES TypeTransactions(id_type_trans)
)
ENGINE=INNODB;

INSERT INTO NameTransactions (id_name_trans, name_trans, type_name_trans) VALUES 
	(1, "versement", 1),
	(2, "transfert", 2),
	(3, "envoi", 2),
	(4, "encaissement", 1),
	(5, "Frais", 2),
	(6, "Intérêts", 2);

CREATE TABLE IF NOT EXISTS Descriptions (
	id_descriptions INT UNSIGNED NOT NULL AUTO_INCREMENT,
	description VARCHAR(40) NOT NULL,
	PRIMARY KEY (id_descriptions)
)
ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS CostsDetailsTransactions (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	trans_id_trans INT UNSIGNED NOT NULL, 
	amount DECIMAL(6,2) NOT NULL,
	type_trans INT UNSIGNED NOT NULL, 
	name_trans INT UNSIGNED NOT NULL,
	to_from_user INT UNSIGNED NOT NULL, 
	description_id INT UNSIGNED, 
	PRIMARY KEY (id),
	CONSTRAINT fk_number_trans_id_trans 
		FOREIGN KEY (trans_id_trans) 
		REFERENCES Transactions(id_trans),
	CONSTRAINT fk_type_trans_id_type_trans 
		FOREIGN KEY (type_trans) 
		REFERENCES TypeTransactions(id_type_trans),	
	CONSTRAINT fk_name_trans_id_trans 
		FOREIGN KEY (name_trans) 
		REFERENCES NameTransactions(id_name_trans),
	CONSTRAINT fk_to_from_user 
		FOREIGN KEY (to_from_user) 
		REFERENCES Users(id_users),
	CONSTRAINT fk_description_id 
		FOREIGN KEY (description_id) 
		REFERENCES Descriptions(id_descriptions)
)
ENGINE=INNODB;

/*insert a transaction for 1 = add money and send to 3*/
/*insert a transaction for 2 = add money*/
/*DUPONT Jack have 30 and send 10 to MARTIN Sébastien*/
/*So collection money 0,5% per transaction*/
/*user 3 recover in your acount bank the amount recieved*/
INSERT INTO Transactions (id_trans, date_trans, user) VALUES 
	(1, "2023-01-26", 1),
	(2, "2023-01-26", 3),
	(3, "2023-02-03", 2),
	(4, "2023-2-05", 3);


INSERT INTO Descriptions (id_descriptions, description) VALUES 
	(1, "remb. ciné");

INSERT INTO CostsDetailsTransactions (id, trans_id_trans, amount, type_trans, name_trans, to_from_user, description_id) VALUES 
	(1, 1, 30, 1, 1, 1, null),
	(2, 1, 10, 2, 3, 3, 1),
	(3, 1, 0.05, 2, 5, 1, null),
	(4, 2, 10, 1, 4, 1, 1),
	(5, 3, 10, 2, 2, 2, null),
	(6, 4, 50, 1, 1, 3, null);


CREATE TABLE IF NOT EXISTS Invoices (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	date_inv DATETIME NOT NULL,
	id_trans INT UNSIGNED NOT NULL,
	inv_number VARCHAR(20) NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT fk_id_trans_id_trans
		FOREIGN KEY (id_trans) 
		REFERENCES Transactions(id_trans)
)
ENGINE=INNODB;
