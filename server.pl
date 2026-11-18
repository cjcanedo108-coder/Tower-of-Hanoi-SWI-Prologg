% ============================================================
% TOWER OF HANOI - SWI-PROLOG PROJECT
% Run: swipl server.pl
% Browser: http://localhost:8080
% Console demo: ?- hanoi(3).
% ============================================================

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_files)).
:- use_module(library(error)).

% Locate hanoi.html in the same folder as this Prolog file.
:- prolog_load_context(directory, Dir),
   asserta(user:file_search_path(hanoi_app, Dir)).

% HTTP routes.
:- http_handler(root(.), serve_page, []).
:- http_handler(root(solve), solve_handler, []).

% ------------------------------------------------------------
% TOWER OF HANOI ALGORITHM (implemented in SWI-Prolog)
% Peg numbers for the browser: 0 = left, 1 = middle, 2 = right.
% Each move is returned as a Prolog dict: _{from:From, to:To}.
% ------------------------------------------------------------

hanoi_moves(0, _, _, _, []) :- !.
hanoi_moves(N, From, To, Via, Moves) :-
    must_be(integer, N),
    N > 0,
    M is N - 1,
    hanoi_moves(M, From, Via, To, Before),
    hanoi_moves(M, Via, To, From, After),
    append(Before, [_{from:From, to:To}|After], Moves).

% ------------------------------------------------------------
% COMMAND-LINE DEMONSTRATION
% In the SWI-Prolog prompt, enter: hanoi(3).
% ------------------------------------------------------------

hanoi(N) :-
    must_be(integer, N),
    between(1, 10, N),
    hanoi_moves(N, 0, 2, 1, Moves),
    length(Moves, Total),
    format('~nTower of Hanoi solution for ~d disks~n', [N]),
    format('Minimum number of moves: ~d~n~n', [Total]),
    print_moves(Moves, 1),
    format('~nPuzzle solved!~n', []).

print_moves([], _).
print_moves([Move|Rest], Step) :-
    get_dict(from, Move, From),
    get_dict(to, Move, To),
    peg_name(From, FromName),
    peg_name(To, ToName),
    format('Move ~d: Move the top disk from ~w peg to ~w peg.~n',
           [Step, FromName, ToName]),
    Next is Step + 1,
    print_moves(Rest, Next).

peg_name(0, left).
peg_name(1, middle).
peg_name(2, right).

% Optional command to return the moves as a Prolog list:
% ?- hanoi_moves(3, 0, 2, 1, Moves).

% ------------------------------------------------------------
% WEB SERVER
% ------------------------------------------------------------

serve_page(Request) :-
    http_reply_file(hanoi_app('hanoi.html'), [], Request).

solve_handler(Request) :-
    http_parameters(Request, [n(N, [integer, between(1, 10)])]),
    hanoi_moves(N, 0, 2, 1, Moves),
    length(Moves, Count),
    reply_json_dict(_{n:N, count:Count, moves:Moves}).

% Start the local web server on port 8080.
start :-
    http_server(http_dispatch, [port(8080)]),
    format('Tower of Hanoi server running (SWI-Prolog).~n', []),
    format('Open: http://localhost:8080~n', []).

stop :-
    http_stop_server(8080, []).

% Start the browser server when this file is loaded with: swipl server.pl
:- initialization(start).
