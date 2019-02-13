create view vLeagueTable
as
Select top 100 Users.[first name] as [First Name], Users.surname as [Surname], (sum(Points.points)) as [Total Points] from Points
join Users on Points.userid = Users.id
group by Users.[first name], Users.surname, Users.id
order by (sum(Points.points)) desc 
--create a view to displau the users' name, ID, and total points and puts into descending order

create procedure spUserProfile
@ID int
as
Select Users.[first name] as [First Name], Users.surname as [Surname], (sum(Points.points) - Prizes.[points cost]) as [Total Points (Unspent)], 
Prizes.[points cost] as [Total Points (Spent)] from [Claimed Prizes]
join Users on Users.id = [Claimed Prizes].userid
join Prizes on [Claimed Prizes].prizeid = Prizes.id
join Points on [Claimed Prizes].userid = Points.userid
where Users.id = @ID
group by Users.id, Users.[first name],Users.surname, Prizes.[points cost]
go
--creates a stored procedure that has the user ID passed in as a parameter and returns the users' name, total points (unspent) and total points (spent)


create procedure spClaimedByUser
@ID int
as
Select Users.[first name] as [First Name], Users.surname as [Surname],
(Prizes.[prize name]) as [Item Claimed] from [Claimed Prizes]
join Users on Users.id = [Claimed Prizes].userid
join Prizes on [Claimed Prizes].prizeid = Prizes.id
join Points on [Claimed Prizes].userid = Points.userid
where Users.id = @ID
group by Users.id, Users.[first name],Users.surname, Prizes.[prize name], Prizes.[points cost]
go
--creates a stored procedure that takes in a user ID a parameter and returns the user's name along with a list of items the user has claimed

select * from vLeagueTable
--this selects all from the view LeagueTable
spUserProfile 24
--this passes in the number twenty four as a user ID to retrieve the user's profile. It includes the name, and total amount of spent and unspent points
spClaimedByUser 24
--this passes in the number twenty four as a user ID to retrieve the user's claims. 

insert into [Claimed Prizes] (id, userid, prizeid)
values('34', '24', '2')
-- test data to check if it shows up in user profile

delete from [Claimed Prizes] where id = 34
--remove test data
