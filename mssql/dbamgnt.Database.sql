-- Create a database called dbamgnt based off the model database
-- this ensures that dbamgnt is configured like databases on the server
-- it's executed on.
IF DB_ID('dbamgnt') IS NULL
	EXEC ('CREATE DATABASE dbamgnt') 
