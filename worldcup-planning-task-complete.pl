% Given knowledge base

% 16 teams defined for the round of 16, as the outcome of the group stage:
team(brz).
team(chi).
team(col).
team(uru).
team(fra).
team(nga).
team(ger).
team(alg).
team(ned).
team(mex).
team(crc).
team(gre).
team(arg).
team(sui).
team(bel).
team(usa).
% describing the planned games: Who plays in which named match:
% The predicate "game" has four arguments with the following meaning
%   game(PrevStage, PrevGame, ThisRound, ThisGame)
%        PrevStage: Indicates which round they are coming from
%        PrevGame:  Represents the game or team from the previous round
%        ThisRound: Indicates the name of this round
%        ThisGame:  The identifier of this game
% Round of 16: 
% For these the previous stage "PrevStage" was "group", 
% as we assume the groups stage has been played already, 
% we can put the team names here as "PrevGame".
% The round of 16 has 8 games, represented as "g1"-"g8", 
% in round "r16".
game(group,brz,r16,g1).
game(group,chi,r16,g1).
game(group,col,r16,g2).
game(group,uru,r16,g2).
game(group,fra,r16,g3).
game(group,nga,r16,g3).
game(group,ger,r16,g4).
game(group,alg,r16,g4).
game(group,ned,r16,g5).
game(group,mex,r16,g5).
game(group,crc,r16,g6).
game(group,gre,r16,g6).
game(group,arg,r16,g7).
game(group,sui,r16,g7).
game(group,bel,r16,g8).
game(group,usa,r16,g8).
% Quarter final:
% This is set up as having winning teams from the 
% quarter finals "r16" compete against each other as defined in the
% bracket. So there are four matches. E.g. the winners of game 1 "g1" and
% game 2 "g2" from the round of 16 "r16" play in game "g1" of the 
% quarter finals "r4" 
game(r16,g1,r4,g1).
game(r16,g2,r4,g1).
game(r16,g3,r4,g2).
game(r16,g4,r4,g2).
game(r16,g5,r4,g3).
game(r16,g6,r4,g3).
game(r16,g7,r4,g4).
game(r16,g8,r4,g4).
% The semifinal (in the same way as before, but with four games)
game(r4,g1,r2,g1).
game(r4,g2,r2,g1).
game(r4,g3,r2,g2).
game(r4,g4,r2,g2).
% The final (There is only one game, obviously)
game(r2,g1,final,g1).
game(r2,g2,final,g1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TASK A: Write a rule "playing/3" that determines if
% a team has the potential to play in a given match, given they
% would win all there matches. 

% This first method is an overload for round 16, as round 16 needs the
% group varible to be "group" as there is no previous round value for it
% to be, this is only called when requests for round 16 are done from the
% query or by recursian. This method also makes sure the team exists.
playing(Team, r16, Game):-
    team(Team),
    game(group, Team, r16, Game).

% This method is the main playing function, it is called and checks to see if
% the game being checked is valid, if it is not it takes the data of current
% game and next ound to call it self again and check the next round using the
% current game as the team name, this works all the way from round 16 to the
% finals by using the current game as the team for the next round.
playing(Team, Round, Game):-
    game(NewRound, NewGame, Round, Game),
    playing(Team, NewRound, NewGame).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TASK B: Write a rule "plays/4" that determines when two team could 
% potential play against each other if they'd be winning their 
% previous games.

% This method will check if teams can play each other, it starts by checking
% the teams exist. It check cheks to make sure neither team is out (Part C)
% if both teams are in it uses the compare method to check both teams can be
% in this game, if they can both be in this game it checks to make sure this
% game has not being played before. This is done by getting the first game
% played by the players and comparing the teams, if they have played in it
% the query stops where it is only retuning valid games.
plays(TeamOne, TeamTwo, Round, Game):-
    team(TeamOne),
    team(TeamTwo),
    not(is_out(TeamOne)),
    not(is_out(TeamTwo)),
    compare(TeamOne, TeamTwo, Round, Game),
    once(game(X, _, Round, Game)),
    not(compare(TeamOne, TeamTwo, X, _)).

% This method allows two teams to be check in one call, it calls the already
% made playing method which allows this function to check if each team could
% play in any given game, therefore this method tells us is both teams could
% get to a given game
compare(TeamOne, TeamTwo, Round, Game):-
    playing(TeamOne, Round, Game),
    playing(TeamTwo, Round, Game).

% This is a dynamic value that can be treated as a bool because of the /1
% It lets us store a true or false value for each team that can be changed
% at run time. This can let us know if the team has been kicked out or not
:- dynamic
    is_out/1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TASK C: Extend your solution from B to be able to dynamically add
% information about match outcomes to your system. Do this by implementing a
% dynamic predicate "is_out" which is true if a team has been kicked out.
% Research the "dynamic" keyword in Prolog to implement this dynamic "is_out"
% predicate and modify you "plays/4" rule from task B so that it would only
% return matches that are still possible, e.g. a query like
%   assert(is_out(uru)), plays(ger,T,r2,_).
% should NOT return Uruguay anymore.