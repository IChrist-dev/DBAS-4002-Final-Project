/*
DBAS 4002 - Final Project
Ian Christian
w0480449
DDL Statements
*/

--Initial task of creating all the tables and their structures
USE Election
GO

DECLARE @TCreate varchar(30);
SELECT @TCreate = 'Table Creation Transaction';

BEGIN TRAN @TCreate
USE Election

CREATE TABLE CandidatePersonal (
	candidate_ID int NOT NULL IDENTITY PRIMARY KEY,
	first_name varchar(20) NOT NULL,
	middle_name varchar(20),
	last_name varchar(20) NOT NULL,
	party_ID int,
	officer_author_ID int
);


CREATE TABLE Party (
	party_ID int NOT NULL PRIMARY KEY,
	party_name varchar(20) NOT NULL,
	vote_count int NOT NULL
);

CREATE TABLE OfficerPersonal (
	officer_ID int NOT NULL IDENTITY PRIMARY KEY,
	first_name varchar(20) NOT NULL,
	middle_name varchar(20),
	last_name varchar(20) NOT NULL,
	email varchar(50) NOT NULL,
	officer_account_ID int NOT NULL
);

CREATE TABLE OfficerAccounts (
	officer_account_ID int PRIMARY KEY,
	username varchar(20),
	password_hash varchar(8) UNIQUE		--Passwords would be hash encrypted and stored in hexadecimal format
);

CREATE TABLE VoterPersonal (
	voter_ID int NOT NULL IDENTITY PRIMARY KEY,
	first_name varchar(20) NOT NULL,
	middle_name varchar(20),
	last_name varchar(20) NOT NULL,
	candidate_choice_ID int,
	keycode varchar(6) NOT NULL UNIQUE,
	sin_num varchar(9) NOT NULL UNIQUE,
	has_voted_ID int
);

CREATE TABLE VotedState (
	has_voted_ID int IDENTITY PRIMARY KEY,
	state_name varchar(9)
);

--Include All Foreign Keys

ALTER TABLE CandidatePersonal ADD CONSTRAINT FK_Cand_Party
FOREIGN KEY (party_ID) REFERENCES Party(party_ID);

ALTER TABLE CandidatePersonal ADD CONSTRAINT FK_Cand_Off_Author
FOREIGN KEY (officer_Author_ID) REFERENCES OfficerPersonal(officer_ID);

ALTER TABLE OfficerPersonal ADD CONSTRAINT FK_Off_username
FOREIGN KEY (officer_account_ID) REFERENCES OfficerAccounts(officer_account_ID);

ALTER TABLE VoterPersonal ADD CONSTRAINT FK_Cand_Choice_ID
FOREIGN KEY (candidate_choice_ID) REFERENCES CandidatePersonal(candidate_ID);

ALTER TABLE VoterPersonal ADD CONSTRAINT FK_Voter_Choice
FOREIGN KEY (has_voted_ID) REFERENCES VotedState(has_voted_ID);

IF @@TRANCOUNT > 0
	COMMIT TRAN @TCreate;
ELSE
	ROLLBACK TRAN @TCreate;
GO