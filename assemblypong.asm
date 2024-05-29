; Pong Game in x86 Assembly

STACK SEGMENT PARA STACK
    DB 64 DUP (' ')
STACK ENDS

DATA SEGMENT PARA 'DATA'
    ; Window dimensions and bounds
    WINDOW_WIDTH DW 140h                 ; Width (320 pixels)
    WINDOW_HEIGHT DW 0C8h                ; Height (200 pixels)
    WINDOW_BOUNDS DW 6                   ; Collision boundary

    ; Game state variables
    TIME_AUX DB 0                        ; Aux variable for time checking
    GAME_ACTIVE DB 1                     ; Game active flag
    EXITING_GAME DB 0                    ; Exit game flag
    WINNER_INDEX DB 0                    ; Winner index
    CURRENT_SCENE DB 0                   ; Current scene index

    ; Text strings for display
    TEXT_PLAYER_ONE_POINTS DB '0','$'    ; Player one points
    TEXT_PLAYER_TWO_POINTS DB '0','$'    ; Player two points
    TEXT_GAME_OVER_TITLE DB 'GAME OVER','$' ; Game over title
    TEXT_GAME_OVER_WINNER DB 'Player 0 won','$' ; Winner text
    TEXT_GAME_OVER_PLAY_AGAIN DB 'Press R to play again','$' ; Play again message
    TEXT_GAME_OVER_MAIN_MENU DB 'Press E to exit to main menu','$' ; Main menu message
    TEXT_MAIN_MENU_TITLE DB 'MAIN MENU','$' ; Main menu title
    TEXT_MAIN_MENU_SINGLEPLAYER DB 'SINGLEPLAYER - S KEY','$' ; Singleplayer option
    TEXT_MAIN_MENU_MULTIPLAYER DB 'MULTIPLAYER - M KEY','$' ; Multiplayer option
    TEXT_MAIN_MENU_EXIT DB 'EXIT GAME - E KEY','$' ; Exit game option

    ; Ball and paddle variables
    BALL_ORIGINAL_X DW 0A0h              ; Initial X position of the ball
    BALL_ORIGINAL_Y DW 64h               ; Initial Y position of the ball
    BALL_X DW 0A0h                       ; Current X position of the ball
    BALL_Y DW 64h                        ; Current Y position of the ball
    BALL_SIZE DW 06h                     ; Ball size
    BALL_VELOCITY_X DW 05h               ; Ball horizontal velocity
    BALL_VELOCITY_Y DW 02h               ; Ball vertical velocity

    PADDLE_LEFT_X DW 0Ah                 ; Current X position of the left paddle
    PADDLE_LEFT_Y DW 55h                 ; Current Y position of the left paddle
    PLAYER_ONE_POINTS DB 0               ; Player one points

    PADDLE_RIGHT_X DW 130h               ; Current X position of the right paddle
    PADDLE_RIGHT_Y DW 55h                ; Current Y position of the right paddle
    PLAYER_TWO_POINTS DB 0               ; Player two points

    PADDLE_WIDTH DW 06h                  ; Paddle width
    PADDLE_HEIGHT DW 25h                 ; Paddle height
    PADDLE_VELOCITY DW 0Fh               ; Paddle velocity
DATA ENDS

CODE SEGMENT PARA 'CODE'

MAIN PROC FAR
    ASSUME CS:CODE, DS:DATA, SS:STACK
    PUSH DS
    SUB AX, AX
    PUSH AX
    MOV AX, DATA
    MOV DS, AX
    POP AX
    POP AX

    CALL CLEAR_SCREEN

CHECK_TIME:  ; Main game loop
    CMP EXITING_GAME, 01h
    JE START_EXIT_PROCESS

    CMP CURRENT_SCENE, 00h
    JE SHOW_MAIN_MENU

    CMP GAME_ACTIVE, 00h
    JE SHOW_GAME_OVER

    MOV AH, 2Ch  ; Get system time
    INT 21h      ; CH = hour CL = minute DH = second DL = 1/100 seconds

    CMP DL, TIME_AUX  ; Compare current time with previous time
    JE CHECK_TIME

    MOV TIME_AUX, DL  ; Update time
    CALL CLEAR_SCREEN
    CALL MOVE_BALL
    CALL DRAW_BALL
    CALL MOVE_PADDLES
    CALL DRAW_PADDLES
    CALL DRAW_UI

    JMP CHECK_TIME

SHOW_GAME_OVER:
    CALL DRAW_GAME_OVER_MENU
    JMP CHECK_TIME

SHOW_MAIN_MENU:
    CALL DRAW_MAIN_MENU
    JMP CHECK_TIME

START_EXIT_PROCESS:
    CALL CONCLUDE_EXIT_GAME
    RET
MAIN ENDP

MOVE_BALL PROC NEAR
    ; Move the ball horizontally
    MOV AX, BALL_VELOCITY_X
    ADD BALL_X, AX

    ; Check for boundary collisions and score updates
    MOV AX, WINDOW_BOUNDS
    CMP BALL_X, AX
    JL GIVE_POINT_TO_PLAYER_TWO

    MOV AX, WINDOW_WIDTH
    SUB AX, BALL_SIZE
    SUB AX, WINDOW_BOUNDS
    CMP BALL_X, AX
    JG GIVE_POINT_TO_PLAYER_ONE
    JMP MOVE_BALL_VERTICALLY

GIVE_POINT_TO_PLAYER_ONE:
    INC PLAYER_ONE_POINTS
    CALL RESET_BALL_POSITION
    CALL UPDATE_TEXT_PLAYER_ONE_POINTS
    CMP PLAYER_ONE_POINTS, 05h
    JGE GAME_OVER
    RET

GIVE_POINT_TO_PLAYER_TWO:
    INC PLAYER_TWO_POINTS
    CALL RESET_BALL_POSITION
    CALL UPDATE_TEXT_PLAYER_TWO_POINTS
    CMP PLAYER_TWO_POINTS, 05h
    JGE GAME_OVER
    RET

GAME_OVER:
    CMP PLAYER_ONE_POINTS, 05h
    JNL WINNER_IS_PLAYER_ONE
    JMP WINNER_IS_PLAYER_TWO

WINNER_IS_PLAYER_ONE:
    MOV WINNER_INDEX, 01h
    JMP CONTINUE_GAME_OVER
WINNER_IS_PLAYER_TWO:
    MOV WINNER_INDEX, 02h
    JMP CONTINUE_GAME_OVER

CONTINUE_GAME_OVER:
    MOV PLAYER_ONE_POINTS, 00h
    MOV PLAYER_TWO_POINTS, 00h
    CALL UPDATE_TEXT_PLAYER_ONE_POINTS
    CALL UPDATE_TEXT_PLAYER_TWO_POINTS
    MOV GAME_ACTIVE, 00h
    RET

; Move the ball vertically
MOVE_BALL_VERTICALLY:
    MOV AX, BALL_VELOCITY_Y
    ADD BALL_Y, AX

    ; Check for vertical boundary collisions
    MOV AX, WINDOW_BOUNDS
    CMP BALL_Y, AX
    JL NEG_VELOCITY_Y

    MOV AX, WINDOW_HEIGHT
    SUB AX, BALL_SIZE
    SUB AX, WINDOW_BOUNDS
    CMP BALL_Y, AX
    JG NEG_VELOCITY_Y

    ; Check for paddle collisions
    MOV AX, BALL_X
    ADD AX, BALL_SIZE
    CMP AX, PADDLE_RIGHT_X
    JNG CHECK_COLLISION_WITH_LEFT_PADDLE

    MOV AX, PADDLE_RIGHT_X
    ADD AX, PADDLE_WIDTH
    CMP BALL_X, AX
    JNL CHECK_COLLISION_WITH_LEFT_PADDLE

    MOV AX, BALL_Y
    ADD AX, BALL_SIZE
    CMP AX, PADDLE_RIGHT_Y
    JNG CHECK_COLLISION_WITH_LEFT_PADDLE

    MOV AX, PADDLE_RIGHT_Y
    ADD AX, PADDLE_HEIGHT
    CMP BALL_Y, AX
    JNL CHECK_COLLISION_WITH_LEFT_PADDLE

    ; Ball collides with right paddle
    JMP NEG_VELOCITY_X

CHECK_COLLISION_WITH_LEFT_PADDLE:
    MOV AX, BALL_X
    ADD AX, BALL_SIZE
    CMP AX, PADDLE_LEFT_X
    JNG EXIT_COLLISION_CHECK

    MOV AX, PADDLE_LEFT_X
    ADD AX, PADDLE_WIDTH
    CMP BALL_X, AX
    JNL EXIT_COLLISION_CHECK

    MOV AX, BALL_Y
    ADD AX, BALL_SIZE
    CMP AX, PADDLE_LEFT_Y
    JNG EXIT_COLLISION_CHECK

    MOV AX, PADDLE_LEFT_Y
    ADD AX, PADDLE_HEIGHT
    CMP BALL_Y, AX
    JNL EXIT_COLLISION_CHECK

    ; Ball collides with left paddle
    JMP NEG_VELOCITY_X

NEG_VELOCITY_Y:
    NEG BALL_VELOCITY_Y
    RET
NEG_VELOCITY_X:
    NEG BALL_VELOCITY_X
    RET
EXIT_COLLISION_CHECK:
    RET
MOVE_BALL ENDP

DRAW_BALL PROC NEAR
    MOV AX, BALL_X
    MOV BX, BALL_Y
    CALL DRAW_SQUARE
    RET
DRAW_BALL ENDP

DRAW_SQUARE PROC NEAR
    ; Placeholder for drawing logic
    ; Example drawing logic (not implemented)
    ; MOV CX, [width]
    ; MOV DX, [height]
    ; MOV ES, [segment]
    ; MOV DI, [offset]
    ; Use BIOS or custom routines to draw the square
    RET
DRAW_SQUARE ENDP

CLEAR_SCREEN PROC NEAR
    ; Clear the screen
    MOV AH, 0
    MOV AL, 3
    INT 10h
    RET
CLEAR_SCREEN ENDP

MOVE_PADDLES PROC NEAR
    ; Placeholder for paddle movement logic
    ; Example:
    ; Check for key presses and update paddle positions
    RET
MOVE_PADDLES ENDP

DRAW_PADDLES PROC NEAR
    ; Placeholder for drawing paddles
    ; Example:
    ; Use BIOS or custom routines to draw paddles at PADDLE_LEFT_X/Y and PADDLE_RIGHT_X/Y
    RET
DRAW_PADDLES ENDP

DRAW_UI PROC NEAR
    ; Placeholder for drawing the user interface
    ; Example:
    ; Draw scores and other UI elements
    RET
DRAW_UI ENDP

DRAW_GAME_OVER_MENU PROC NEAR
    ; Placeholder for drawing the game over menu
    RET
DRAW_GAME_OVER_MENU ENDP

DRAW_MAIN_MENU PROC NEAR
    ; Placeholder for drawing the main menu
    RET
DRAW_MAIN_MENU ENDP

UPDATE_TEXT_PLAYER_ONE_POINTS PROC NEAR
    ; Update the text string for player one points
    ; Placeholder logic
    RET
UPDATE_TEXT_PLAYER_ONE_POINTS ENDP

UPDATE_TEXT_PLAYER_TWO_POINTS PROC NEAR
    ; Update the text string for player two points
    ; Placeholder logic
    RET
UPDATE_TEXT_PLAYER_TWO_POINTS ENDP

RESET_BALL_POSITION PROC NEAR
    ; Reset ball position to the center
    MOV BALL_X, BALL_ORIGINAL_X
    MOV BALL_Y, BALL_ORIGINAL_Y
    RET
RESET_BALL_POSITION ENDP

CONCLUDE_EXIT_GAME PROC NEAR
    ; Conclude and exit the game
    MOV AH, 4Ch
    MOV AL, 00h
    INT 21h
    RET
CONCLUDE_EXIT_GAME ENDP

CODE ENDS
END MAIN
