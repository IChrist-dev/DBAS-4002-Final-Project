/*
DBAS 4002 - Final Project
Ian Christian
w0480449
DDL Statements
*/

--Process to clear all data records in all tables without deleting their schema
USE Election
GO

CREATE PROC clearAllTables
AS
BEGIN
	--First unbind all the tables
	ALTER TABLE CandidatePersonal
	DROP CONSTRAINT FK_Cand_Party, FK_Cand_Off_Author;
	ALTER TABLE OfficerPersonal
	DROP CONSTRAINT FK_Off_username;
	ALTER TABLE VoterPersonal
	DROP CONSTRAINT FK_Cand_Choice_ID, FK_Voter_Choice;

	--Then truncate all the tables at once
	TRUNCATE TABLE CandidatePersonal;
	TRUNCATE TABLE Party;
	TRUNCATE TABLE OfficerPersonal;
	TRUNCATE TABLE OfficerAccounts;	
	TRUNCATE TABLE VoterPersonal;
	TRUNCATE TABLE VotedState;

	--Re-establish foreign-key relationships
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
END;
GO

--Demonstrate the clearAllTables procedure
DECLARE @Tdel varchar(40);
SELECT @Tdel = 'Delete all records transaction';

BEGIN TRAN @Tdel
EXEC clearAllTables;
IF @@TRANCOUNT > 0
	COMMIT TRAN @Tdel;
ELSE
	ROLLBACK TRAN @Tdel;
GO