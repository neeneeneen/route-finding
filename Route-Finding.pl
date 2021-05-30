/*
COMP304 Assignment 4 
*/

/* As an overview of the assignment, I found that there is some error with my choices which could be influenced by my route function. There are a
few tests at the bottom which demonstrate the functionality of each function and are in form : t1(). Though individually, the route function does work as intended
but seem to provide some error upon being used with findall. */

printVisits([]).
printVisits([H|T]) :- 
write(H),write(' '),printVisits(T).

printChoices([]).
printChoices([H|T]) :- 
write(H),nl,printChoices(T).
/*
Defining the database 
*/

road(wellington, palmerstonNorth).
road(palmerstonNorth, wanganui).
road(palmerstonNorth, napier).
road(palmerstonNorth, taupo).
road(wanganui, taupo).
road(wanganui, newPlymouth).
road(wanganui, napier).
road(napier, taupo).
road(napier, gisborne).
road(newPlymouth, hamilton).
road(newPlymouth, taupo).
road(taupo, hamilton).
road(taupo, rotorua).
road(taupo, gisborne).
road(gisborne, rotorua).
road(rotorua, hamilton).
road(hamilton, auckland).

road(_, _).

/*
Defining the database with distances
*/

road(wellington, palmerstonNorth, 143).
road(palmerstonNorth, wanganui, 74).
road(palmerstonNorth, napier, 178).
road(palmerstonNorth, taupo, 259).
road(wanganui, taupo, 231).
road(wanganui, newPlymouth, 163).
road(wanganui, napier, 252).
road(napier, taupo, 147).
road(napier, gisborne, 215).
road(newPlymouth, hamilton, 242).
road(newPlymouth, taupo, 289).
road(taupo, hamilton, 153).
road(taupo, rotorua, 82).
road(taupo, gisborne, 334).
road(gisborne, rotorua, 291).
road(rotorua, hamilton, 109).
road(hamilton, auckland, 126).

road(_, _, 0).

/* Provides the functionality of a bidirectional road */
connection(Start, Finish) :- road(Start, Finish) ; road(Finish, Start).


route(Start, Finish, Visits) :- 
    /* Initial case where we initialise visits with the starting location 
    The function returns X, Visits is appended to */
    findRoute(Start, Finish, [Start], Visits).

/* Base case */
route(_, _, []).

/* Stopping case when a path is found */ 
findRoute(Start, Finish, Visits, Visits) :- 
    Start == Finish.

findRoute(Start, End, CurrentVisited, Visits) :-
    connection(Start, Neighbour), 
    \+member(Neighbour, CurrentVisited),
    append(CurrentVisited, [Neighbour], UpdatedVisit), 
    findRoute(Neighbour, End, UpdatedVisit, Visits).

findRoute(_, _, [], []).

/* Similar to route/3 but with distance calculation implemented*/ 
route(Start, Finish, Visits, Distance) :-
    findRoute(Start, Finish, [Start], Visits, 0, Distance).

route(_, _, [], 0).

findRoute(Start, Finish, Visited, Visited, Distance, Distance) :- 
    Start == Finish.

findRoute(Start, End, CurrentVisited, Visits, CurrentDistance, Distance) :-
    connection(Start, Neighbour), 
    \+member(Neighbour, CurrentVisited),
    append(CurrentVisited, [Neighbour], UpdatedVisit),
    road(Start, Neighbour, Dist),
    UpdatedDistance is CurrentDistance + Dist,
    findRoute(Neighbour, End, UpdatedVisit, Visits, UpdatedDistance, Distance).

findRoute(Start, End, CurrentVisited, Visits, CurrentDistance, Distance) :-
    connection(Start, Neighbour), 
    \+member(Neighbour, CurrentVisited),
    append(CurrentVisited, [Neighbour], UpdatedVisit),
    road(Neighbour, Start, Dist),
    UpdatedDistance is CurrentDistance + Dist,
    findRoute(Neighbour, End, UpdatedVisit, Visits, UpdatedDistance, Distance).

findRoute(_, _, [], [], 0, 0).

/* Find all possible routes from Start to Finish using findall/3 */
choice(Start, Finish, RoutesAndDistances) :- 
    findall((Visits, Distance), route(Start, Finish, Visits, Distance), RoutesAndDistances).

choice(_, _, []).

/* Simple tests for route/4*/
t1() :-
    route(palmerstonNorth, taupo, X, D),
    printVisits(X),
    nl,
    write('Distance: '),write(D).
t2() :- 
    route(wellington, auckland, X, D),
    printVisits(X),
    nl,
    write('Distance: '),write(D).

/* Demonstrates bidirectionality of function */
t3() :-
    route(auckland, wellington, X, D),
    printVisits(X),
    nl,
    write('Distance: '),write(D).

/* This should fail as queenstown does not exist in the database */
t4() :-
    route(wellington, queenstown, X, D),
    printVisits(X),
    nl,
    write('Distance: '),write(D).

/* This test prints out the same list of cities multiple times with distances, however I am quite unsure if it is in order 
might be a problem with route */
t5() :-
    choice(wellington, wanganui, Z),
    printChoices(Z).

/* Outputs an empty list and a 0 as the locations are not part of the database */
t6() :- 
    choice(levin, christchurch, Z),
    printChoices(Z).

/* Demonstrates bi-directionality. Some output produces 0 distance which is false so it isn't fully functional */
t7() :- 
    choice(gisborne, wellington, Z),
    printChoices(Z).

