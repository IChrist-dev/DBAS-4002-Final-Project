/*
DBAS 4002 - Final Project
Ian Christian
w0480449
DDL Statements
*/

--Separate processes for modifying pre-existing records in candidate, officer, and voter tables
USE Election;
GO

--Update candidate information
CREATE PROC updateCandidate
	@cand_ID int,
	@new_c_first_name varchar(20),
	@new_c_middle_name varchar(20) = NULL,
	@new_c_last_name varchar(20),
	@party_ID int,
	@new_c_party_name varchar(20),
	@new_c_officer_author_ID int
AS
BEGIN
UPDATE Party
SET party_name = @new_c_party_name
WHERE party_ID = @party_ID;			--Check to only update the record provided during process execution
UPDATE CandidatePersonal
SET first_name = @new_c_first_name, middle_name = @new_c_middle_name, last_name = @new_c_last_name
WHERE candidate_ID = @cand_ID;		--Check to only update the record provided during process execution

END;
GO

--Update officer login credentials
CREATE PROC updateOfficerLogin
	@officer_account_ID int,
	@old_o_username varchar(20),
	@new_o_username varchar(20),
	@new_o_password_hash varchar(8)
AS
BEGIN
UPDATE OfficerAccounts
SET username = @new_o_username, password_hash = @new_o_password_hash
WHERE officer_account_ID = @officer_account_ID;	--Check to only update the record provided during process execution

END;
GO

--Update voter information
CREATE PROC updateVoter
	@voter_ID int,
	@new_v_first_name varchar(20),
	@new_v_middle_name varchar(20) = NULL,
	@new_v_last_name varchar(20),
	@new_v_keycode varchar(6),
	@sin_num varchar(9)
AS
BEGIN
UPDATE VoterPersonal
SET first_name = @new_v_first_name, middle_name = @new_v_middle_name, last_name = @new_v_last_name, keycode = @new_v_keycode
WHERE sin_num = @sin_num;			--Check to only update the record provided during process execution

END;
GO

--Cast vote for a specific voter
CREATE PROC voterCastVote
	@voter_ID int,
	@keycode varchar(6),
	@candidate_choice_ID int
AS
BEGIN
UPDATE VoterPersonal
SET candidate_choice_ID = @candidate_choice_ID, has_voted_ID = 2
WHERE voter_ID = @voter_ID AND keycode = @keycode;

END;
GO


DECLARE @T4 varchar(30);
DECLARE @S5 varchar(30);
DECLARE @S6 varchar(30);
DECLARE @S7 varchar(30);
SELECT @T4 = 'Update candidate info';
SELECT @S5 = 'Pre-modified candidate state';
SELECT @S6 = 'Pre-modified officer state';
SELECT @S7 = 'Pre-voter has-voted state';

BEGIN TRAN @T4;

--Demonstrate modifying a candidate record using the updateCandidate process
SAVE TRAN @S5
EXEC updateCandidate 2, 'Harry', 'James', 'Potter', 1, 'Gryffindor', 2;
--Conditional check to ensure the update process worked
IF NOT EXISTS(SELECT 2 FROM CandidatePersonal WHERE first_name = 'Harry')
	ROLLBACK TRAN @S5;

--Demonstrate modifying an officer record using the updateCandidate process
SAVE TRAN @S6
EXEC updateOfficerLogin 2, 'pearL123', 'lestpears111', 'f8g92da4';
--Conditional check to ensure the update process worked
IF NOT EXISTS(SELECT 2 FROM OfficerAccounts WHERE username = 'lestpears111')
	ROLLBACK TRAN @S6;

--Update each voter's vote choice status via the voterCastVote procedure. 
--Note - this also triggers the party vote_count to update
SAVE TRAN @S7
EXEC voterCastVote 1, 'f93h31', 1;
EXEC voterCastVote 2, '89w53a', 2;
EXEC voterCastVote 3, 'f645kh', 2;
EXEC voterCastVote 4, '99ht6n', 1;
EXEC voterCastVote 5, 'op9h04', 1;
EXEC voterCastVote 6, 'ggb0mi', 2;
EXEC voterCastVote 7, 'almn0k', 3;
EXEC voterCastVote 8, 'zcmfx6', 1;
EXEC voterCastVote 9, 'ru89ez', 3;
EXEC voterCastVote 10, 's890ij', 3;
EXEC voterCastVote 11, 'a45jhc', 3;
EXEC voterCastVote 12, 'f90ikl', 3;
EXEC voterCastVote 13, 'g4cnxc', 2;
EXEC voterCastVote 14, '453i90', 3;
EXEC voterCastVote 15, '12334m', 1;
EXEC voterCastVote 16, '587f9a', 2;
EXEC voterCastVote 17, '086vg8', 3;
EXEC voterCastVote 18, 'zsuvtd', 1;
EXEC voterCastVote 19, 'q5d7v0', 3;
EXEC voterCastVote 20, 't6bia3', 3;
--Conditional check to ensure the vote casting process worked
IF NOT EXISTS(SELECT 1 FROM VoterPersonal WHERE has_voted_ID = 2)
	ROLLBACK TRAN @S7;

IF @@TRANCOUNT > 0
	COMMIT TRAN @T4;
ELSE
	ROLLBACK TRAN @T4;
GO