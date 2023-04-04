/*
DBAS 4002 - Final Project
Ian Christian
w0480449
DDL Statements
*/

--Scripts to fetch various reports as outlined in project document
USE Election
GO

--View the top 2 candidates based on vote count
CREATE OR ALTER VIEW topTwoCandidates
AS
	SELECT TOP 2
	candidate_ID AS 'ID #',
	cand.first_name + ' ' + cand.last_name AS 'Name',
	p.vote_count AS 'Vote Count'
	FROM CandidatePersonal cand
	INNER JOIN Party p
	ON p.party_ID = cand.party_ID
	GROUP BY cand.candidate_ID,
	cand.first_name,
	cand.last_name,
	p.vote_count
	ORDER BY p.vote_count DESC
;

GO
--Demonstrate the view
SELECT * FROM topTwoCandidates;
GO

--View the candidate with the least votes
CREATE OR ALTER VIEW losingCandidate
AS
	SELECT TOP 1
	candidate_ID AS 'ID #',
	cand.first_name + ' ' + cand.last_name AS 'Name',
	p.vote_count AS 'Vote Count'
	FROM CandidatePersonal cand
	INNER JOIN Party p
	ON p.party_ID = cand.party_ID
	GROUP BY cand.candidate_ID,
	cand.first_name,
	cand.last_name,
	p.vote_count
	ORDER BY p.vote_count ASC		--Shows the record with lowest value first. Top 1 ensures only this record is shown
;

GO
--Demonstrate the view
SELECT * FROM losingCandidate;
GO

--View the candidates with votes between 5 and 15
CREATE OR ALTER VIEW votes5to15
AS
	SELECT	candidate_ID AS 'ID #',
	cand.first_name + ' ' + cand.last_name AS 'Name',
	p.vote_count AS 'Vote Count'
	FROM CandidatePersonal cand
	INNER JOIN Party p
	ON p.party_ID = cand.party_ID
	WHERE p.vote_count >= 5 AND p.vote_count <= 15
;

GO
--Demonstrate the view
SELECT * FROM votes5to15;
GO

--View the voting record for each candidate
CREATE OR ALTER VIEW voteRecordTotal
AS
	SELECT candidate_ID AS 'ID #',
	cand.first_name + ' ' + cand.last_name AS 'Name',
	p.vote_count AS 'Vote Count'
	FROM CandidatePersonal cand
	INNER JOIN Party p
	ON p.party_ID = cand.party_ID
;

GO
--Demonstrate the view
SELECT * FROM voteRecordTotal;
GO

--View to display the winner
CREATE OR ALTER VIEW declareWinner
AS
	SELECT TOP 1
	candidate_ID AS 'ID #',
	cand.first_name + ' ' + cand.last_name AS 'Name',
	p.vote_count AS 'Vote Count'
	FROM CandidatePersonal cand
	INNER JOIN Party p
	ON p.party_ID = cand.party_ID
	GROUP BY cand.candidate_ID,
	cand.first_name,
	cand.last_name,
	p.vote_count
	ORDER BY p.vote_count DESC
;

GO
--Demonstrate the view
SELECT * FROM declareWinner;