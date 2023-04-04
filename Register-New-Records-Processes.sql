/*
DBAS 4002 - Final Project
Ian Christian
w0480449
DDL Statements
*/

--Separate processes to register new voters, candidates, and officers
USE Election
GO

--Register new voter record from scratch
CREATE PROC insertNewVoter
	@v_first_name varchar(20),
	@v_middle_name varchar(20) = NULL,
	@v_last_name varchar(20),
	@v_keycode varchar(6),
	@v_sin varchar(9)
AS
BEGIN
	INSERT INTO VoterPersonal (first_name, middle_name, last_name, keycode, sin_num, has_voted_ID)
	VALUES (@v_first_name, @v_middle_name, @v_last_name, @v_keycode, @v_sin, 1);
END;
GO

--Register new candidate record from scratch
CREATE PROC insertNewCandidate
	@c_first_name varchar(20),
	@c_middle_name varchar(20) = NULL,
	@c_last_name varchar(20),
	@c_party_ID int,
	@c_party_name varchar(20),
	@c_officer_author_ID int
AS
BEGIN
	INSERT INTO Party (party_ID, party_name, vote_count)
	VALUES (@c_party_ID, @c_party_name, 0);		--Vote counts always start at 0 for a new candidate
	INSERT INTO CandidatePersonal (first_name, middle_name, last_name, party_ID, officer_author_ID)
	VALUES (@c_first_name, @c_middle_name, @c_last_name, @c_party_ID, @c_officer_author_ID);

END;
GO

--Register new officer record from scratch
CREATE PROC insertNewOfficer
	@o_first_name varchar(20),
	@o_middle_name varchar(20) = NULL,
	@o_last_name varchar(20),
	@o_email varchar(50),
	@o_account_ID int,
	@o_username varchar(20),
	@o_password_hash varchar(8)
AS
BEGIN
	INSERT INTO OfficerAccounts (officer_account_ID, username, password_hash)
	VALUES (@o_account_ID, @o_username, @o_password_hash);
	INSERT INTO OfficerPersonal (first_name, middle_name, last_name, email, officer_account_ID)
	VALUES (@o_first_name, @o_middle_name, @o_last_name, @o_email, @o_account_ID);
END;
GO

--Trigger to automatically update the candidate vote count anytime a voter_choice is inserted or updated
CREATE TRIGGER vote_update_tr
ON VoterPersonal
AFTER UPDATE
AS
BEGIN
	IF (UPDATE(candidate_choice_ID))
	BEGIN
		UPDATE Party
		SET vote_count = vote_count + 1
		FROM Party
		INNER JOIN CandidatePersonal ON Party.party_ID = CandidatePersonal.party_ID
		INNER JOIN VoterPersonal ON CandidatePersonal.candidate_ID = VoterPersonal.candidate_choice_ID
		WHERE VoterPersonal.candidate_choice_ID = CandidatePersonal.candidate_ID
		AND CandidatePersonal.candidate_ID = (SELECT candidate_choice_ID FROM inserted);	
		--Ensure only the specific Party record is updated when trigger fires, not all records in Party table
	END
END;
GO


--Demonstrate the previously defined processes to fill tables with example records
DECLARE @TNewRec varchar(40);
SELECT @TNewRec = 'Register new records transaction';
--Savepoints for each table insertion
DECLARE @S1 varchar(30);
DECLARE @S2 varchar(30);
DECLARE @S3 varchar(30);
DECLARE @S4 varchar(30);
SELECT @S1 = 'VotedState empty state';
SELECT @S2 = 'OfficerPersonal empty state';
SELECT @S3 = 'CandidatePersonal empty state';
SELECT @S4 = 'VoterPersonal empty state';


BEGIN TRAN @TNewRec;
USE Election

SAVE TRAN @S1
INSERT INTO VotedState (state_name)
VALUES ('false'),
('true');
--Rollback if the previous insert failed
IF NOT EXISTS (SELECT * FROM VotedState)
	ROLLBACK TRAN @S1;


--Demonstrate registering a new officer using the appropriate process	
SAVE TRAN @S2
EXEC insertNewOfficer 'Emily', 'Reese', 'Smith', 'esmith@gmail.com', 1, 'eSmith999', '7c74a549';
EXEC insertNewOfficer 'Lester', 'Bowles', 'Pearson', 'lestpear@hotmail.com', 2, 'pearL123', '8f2e9b15';
EXEC insertNewOfficer 'John', NULL, 'Diefenbaker', 'jdiefen123@gmail.com', 3, 'johnD1000', '6b9e0d67';
--Rollback if the previous insert failed
IF NOT EXISTS (SELECT * FROM OfficerPersonal)
	ROLLBACK TRAN @S2;

--Demonstrate registering a new candidate using the appropriate process
SAVE TRAN @S3
EXEC insertNewCandidate 'Bruce', 'Thomas', 'Wayne', 1, 'Liberal', 2;
EXEC insertNewCandidate 'Harvey', NULL, 'Dent', 2, 'Conservative', 1;
EXEC insertNewCandidate 'Selina', 'Cattus', 'Kyle', 3, 'NDP', 3;
--Rollback if the previous insert failed
IF NOT EXISTS (SELECT * FROM CandidatePersonal)
	ROLLBACK TRAN @S3;

--Demonstrate registering new voters using the appropriate process
SAVE TRAN @S4
EXEC insertNewVoter 'John', 'Michael', 'Smith', 'f93h31', '358217649';
EXEC insertNewVoter 'Mary', NULL, 'Jones', '89w53a', '974125836';
EXEC insertNewVoter 'Robert', 'Lee', 'Williams', 'f645kh', '621843957';
EXEC insertNewVoter 'Catherine', 'Grace', 'Brown', '99ht6n', '238749106';
EXEC insertNewVoter 'David', NULL, 'Miller', 'op9h04', '816394257';
EXEC insertNewVoter 'Elise', 'Marie', 'Davis', 'ggb0mi', '495681230';
EXEC insertNewVoter 'Andrew', 'William', 'Johnson', 'almn0k', '732105498';
EXEC insertNewVoter 'Sarah', NULL, 'Wilson', 'zcmfx6', '157649283';
EXEC insertNewVoter 'James', 'Robert', 'Taylor', 'ru89ez', '369247105';
EXEC insertNewVoter 'Olivia', 'Ann', 'Martin', 's890ij', '824576139';
EXEC insertNewVoter 'Henri', 'de', 'Gaulle', 'a45jhc', '591634820';
EXEC insertNewVoter 'Paul', NULL, 'Verlaine', 'f90ikl', '267108395';
EXEC insertNewVoter 'Henry', 'Indiana', 'Jones', 'g4cnxc', '983245716';
EXEC insertNewVoter 'Henri', 'Robert-Marcel', 'Duchamp', '453i90', '410583627';
EXEC insertNewVoter 'Madison', 'Elise', 'Bryant', '12334m', '186472503';
EXEC insertNewVoter 'Ethan', 'Jacob', 'Hernandez', '587f9a', '543281240';
EXEC insertNewVoter 'Avery', 'Marie', 'Jones', '086vg8', '130090725';
EXEC insertNewVoter 'Chloe', 'Ann', 'Patel', 'zsuvtd', '138908457';
EXEC insertNewVoter 'Gabriel', 'Daniel', 'Lee', 'q5d7v0', '783218219';
EXEC insertNewVoter 'Aria', 'Nicole', 'Mabel', 't6bia3', '784216576';

--Rollback if the previous insert failed
IF NOT EXISTS (SELECT * FROM VoterPersonal)
	ROLLBACK TRAN @S4;
IF @@TRANCOUNT > 0
	COMMIT TRAN @TNewRec;
ELSE
	ROLLBACK TRAN @TNewRec;
GO