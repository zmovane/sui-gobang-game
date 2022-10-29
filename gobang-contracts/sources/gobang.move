// Copyright (c) 2022, Amovane@163.com
// SPDX-License-Identifier: Apache-2.0
module game::gobang {
    use std::vector;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::math::{min, max};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    const ROWS: u8 = 15;
    const COLS: u8 = 15;
    const LEN: u8 = 5;

    // Game status
    const IN_PROGRESS: u8 = 0;
    const W_WIN: u8 = 1;
    const B_WIN: u8 = 2;
    const DRAW: u8 = 3;
    const FINAL_TURN: u8 = 15 * 15;

    // Mark type
    const MARK_EMPTY: u8 = 0;

    // Error codes
    const ENoGrantToCreateGame: u64 = 0;
    const EInvalidTurn: u64 = 1;
    const EGameEnded: u64 = 2;
    const EInvalidLocation: u64 = 3;
    const ECellOccupied: u64 = 4;

    struct Gobang has key {
        id: UID,
        gameboard: vector<vector<u8>>,
        cur_turn: u8,
        game_status: u8,
        w_address: address,
        b_address: address,
    }

    struct Trophy has key {
        id: UID,
    }

    struct GameEndEvent has copy, drop {
        game_id: ID,
    }

    fun new_gameboard() : vector<vector<u8>>{
        let board = vector<vector<u8>>[];
        let n = 0;
        while (n < ROWS){
            let row = vector<u8>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            vector::push_back(&mut board, row);
            n = n + 1;
        };
        board
    }

    /// `w_address` and `b_address` are the account address of the two players.
    public entry fun create_game(w_address: address, b_address: address, ctx: &mut TxContext) {
        assert!(@game == tx_context::sender(ctx), ENoGrantToCreateGame);
        let id = object::new(ctx);
        let gameboard = new_gameboard();
        let game = Gobang {
            id,
            gameboard,
            cur_turn: 0,
            game_status: IN_PROGRESS,
            w_address,
            b_address,
        };
        // Make the game a shared object so that both players can mutate it.
        transfer::share_object(game);
    }

    public entry fun place_mark(game: &mut Gobang, row: u8, col: u8, ctx: &mut TxContext) {
        assert!(row < ROWS && col < COLS, EInvalidLocation);
        assert!(game.game_status == IN_PROGRESS, EGameEnded);
        let addr = get_cur_turn_address(game);
        assert!(addr == tx_context::sender(ctx), EInvalidTurn);

        let cell = vector::borrow_mut(vector::borrow_mut(&mut game.gameboard, (copy row as u64)), (copy col as u64));
        assert!(*cell == MARK_EMPTY, ECellOccupied);

        // Mark as 1 for white piece, and 2 for black piece
        *cell = game.cur_turn % 2 + 1;
        update_winner(game, row, col);
        game.cur_turn = game.cur_turn + 1;

        if (game.game_status != IN_PROGRESS) {
            event::emit(GameEndEvent { game_id: object::id(game) });
            if (game.game_status == W_WIN) {
                transfer::transfer( Trophy { id: object::new(ctx) }, *&game.w_address);
            } else if (game.game_status == B_WIN) {
                transfer::transfer( Trophy { id: object::new(ctx) }, *&game.b_address);
            }
        }
    }

    public entry fun delete_game(game: Gobang) {
        let Gobang { id, gameboard: _, cur_turn: _, game_status: _, w_address: _, b_address: _ } = game;
        object::delete(id);
    }

    public entry fun delete_trophy(trophy: Trophy) {
        let Trophy { id } = trophy;
        object::delete(id);
    }

    public fun get_status(game: &Gobang): u8 {
        game.game_status
    }

    fun get_cur_turn_address(game: &Gobang): address {
        if (game.cur_turn % 2 == 0) {
            *&game.w_address
        } else {
            *&game.b_address
        }
    }

    fun get_cell(game: &Gobang, row: u8, col: u8): u8 {
        *vector::borrow(vector::borrow(&game.gameboard, (copy row as u64)), (copy col as u64))
    }

    fun update_winner(game: &mut Gobang, row: u8,  col: u8) {

        // Check all columns
        check_column(game, row, col);

        // Check all rows
        check_row(game, row, col);

        // Check all diagonals
        check_diagonal(game, row, col);

        // Check if we have a draw
        if (game.game_status == IN_PROGRESS && game.cur_turn == FINAL_TURN) {
            game.game_status = DRAW;
        };
    }

    fun check_column(game: &mut Gobang, row: u8, col: u8) {
        if (game.game_status != IN_PROGRESS) {
            return
        };
        let start_col: u8 = if(col < LEN) 0 else col + 1 - LEN;
        let end_col: u8 = if(col >= COLS - LEN) COLS - 1 else col + LEN - 1;
        let j: u8 = start_col;
        while(j <= end_col + 1 - LEN){
            let result = check_if_all_equal(game, row, j, row, j + 1, row, j + 2, row, j + 3, row, j + 4);
            if (result != MARK_EMPTY) {
                game.game_status = if (result == 1) W_WIN else B_WIN;
            };
            j = j + 1;
        };
    }

    fun check_row(game: &mut Gobang, row: u8, col: u8) {
        if (game.game_status != IN_PROGRESS) {
            return
        };
        let start_row: u8 = if(row < LEN) 0 else row + 1 - LEN;
        let end_row: u8 = if(row >= ROWS - LEN) ROWS - 1 else row + LEN - 1;
        let i: u8 = start_row;
        while(i <= end_row + 1 - LEN){
            let result = check_if_all_equal(game, i, col, i + 1, col, i + 2, col, i + 3, col, i + 4, col);
            if (result != MARK_EMPTY) {
                game.game_status = if (result == 1) W_WIN else B_WIN;
            };
            i = i + 1;
        };
    }

    fun check_diagonal(game: &mut Gobang, row: u8, col: u8) {
        if (game.game_status != IN_PROGRESS) {
            return
        };

        let start_row;
        let start_col;
        let end_row;
        let end_col;

        // left top -> right bottom
        let n = min((copy row as u64), (copy col as u64));
        if ((n as u8) < LEN){
            start_row = row - (copy n as u8);
            start_col = col - (copy n as u8);
        }else{
            start_row = row + 1 - LEN;
            start_col = col + 1 - LEN;
        };

        let m = max((copy row as u64), (copy col as u64));
        if((m as u8) >= ROWS - LEN){
            end_row = row + (ROWS - (copy m as u8) - 1);
            end_col = col + (ROWS - (copy m as u8) - 1);
        }else{
            end_row = row + LEN - 1;
            end_col = col + LEN - 1;
        };
        
        let i = start_row;
        let j = start_col;
        if(end_row + 1 >= LEN && end_col + 1 >= LEN){
            while(i <= end_row + 1 - LEN && j <= end_col + 1 - LEN){
                let result = check_if_all_equal(game, i, j, i + 1, j + 1, i + 2, j + 2, i + 3, j + 3, i + 4, j + 4);
                if (result != MARK_EMPTY) {
                    game.game_status = if (result == 1) W_WIN else B_WIN;
                };
                i = i + 1;
                j = j + 1;
            };
        };

        // right top -> left bottom
        let reversed_col = COLS - col - 1;
        n = min((copy row as u64), (copy reversed_col as u64));
        if ((n as u8) < LEN){
            start_row = row - (copy n as u8);
            start_col = col + (copy n as u8);
        }else{
            start_row = row + 1 - LEN;
            start_col = col + LEN - 1;
        };

        m = max((copy row as u64), (copy reversed_col as u64));
        if((m as u8) >= ROWS - LEN){
            end_row = row + (ROWS - (copy m as u8) - 1);
            end_col = col - (ROWS - (copy m as u8) - 1);
        }else{
            end_row = row + LEN - 1;
            end_col = col + 1 - LEN;
        };

        i = start_row;
        j = start_col;
        while(end_row + 1 >= LEN && i <= end_row + 1 - LEN && j >= end_col + LEN - 1){
            let result = check_if_all_equal(game, i, j, i + 1, j - 1, i + 2, j - 2, i + 3, j - 3, i + 4, j - 4);
            if (result != MARK_EMPTY) {
                game.game_status = if (result == 1) W_WIN else B_WIN;
            };
            i = i + 1;
            j = j - 1;
        }
    }

    fun check_if_all_equal(game: &Gobang, row1: u8, col1: u8, row2: u8, col2: u8, row3: u8, col3: u8, row4: u8, col4: u8, row5: u8, col5: u8): u8{
        let c1 = get_cell(game, row1, col1);
        let c2 = get_cell(game, row2, col2);
        let c3 = get_cell(game, row3, col3);
        let c4 = get_cell(game, row4, col4);
        let c5 = get_cell(game, row5, col5);
        if (c1 == c2 && c1 == c3 && c1 == c4 && c1 == c5) c1 else MARK_EMPTY
    }
}