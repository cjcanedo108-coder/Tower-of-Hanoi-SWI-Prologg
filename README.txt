TOWER OF HANOI - SWI-PROLOG PROJECT
==================================

REQUIREMENTS
- SWI-Prolog installed on your computer
- A modern web browser

FILES
- server.pl   Prolog algorithm, command-line demonstration, and web server
- hanoi.html  Browser interface for the Tower of Hanoi game

RUN THE PROJECT
1. Extract the ZIP file.
2. Open PowerShell or Command Prompt in the extracted "hanoii" folder.
3. Run:

   swipl server.pl

4. Wait for the message that the Tower of Hanoi server is running.
5. Open this address in your browser:

   http://localhost:8080

TEST THE PROLOG COMMAND
When the SWI-Prolog prompt (?- ) is available, enter:

   hanoi(3).

SWI-Prolog will print the seven required moves for three disks.
Try another number, for example:

   hanoi(4).

To see the raw list of moves, enter:

   hanoi_moves(3, 0, 2, 1, Moves).

The peg numbers are 0 = left, 1 = middle, and 2 = right.

HOW THE BROWSER VERSION WORKS
- The HTML page is served by the SWI-Prolog HTTP server.
- Clicking Auto-solve sends a request to /solve?n=NUMBER.
- The solve_handler in server.pl calls hanoi_moves/5.
- SWI-Prolog returns the calculated moves as JSON.
- The browser displays/animates those Prolog-generated moves.
- Manual disk movement is handled by the browser interface.

IMPORTANT
Do not open hanoi.html directly as a file. Start server.pl first and visit
http://localhost:8080 so the browser can communicate with SWI-Prolog.

To stop the server, press Ctrl+C in the terminal.
