/*
DBAS 4002 - Final Project
Ian Christian
w0480449
DDL Statements
*/

--Process to delete a specific user(Officer) from the database
USE Election
GO

CREATE OR ALTER PROC deleteOfficer
	@officer_ID int,
	@o_username varchar(20),
	@o_password_hash varchar(8)
AS
BEGIN
	UPDATE CandidatePersonal				--Unbind the officer from the candidate they inserted
	SET officer_author_ID = NULL
	WHERE officer_author_ID = @officer_ID;
	DELETE FROM OfficerPersonal				--Remove the corresponding record from the Officer Personal table
	WHERE officer_account_ID = @officer_ID;
	DELETE FROM OfficerAccounts				--Remove the record from the account table
	WHERE officer_account_ID = @officer_ID
	AND username = @o_username
	AND password_hash = @o_password_hash;
END;
GO

--Demonstrate the deleteOfficer procedure
DECLARE @TdelUser varchar(30);
SELECT @TdelUser = 'Delete officer transaction';

BEGIN TRAN @TdelUser
EXEC deleteOfficer 3, 'johnD1000', '6b9e0d67';

IF @@TRANCOUNT > 0
	COMMIT TRAN @TdelUser;
ELSE
	ROLLBACK TRAN @TdelUser;
GO