// Copyright (c) 2022, Amovane@163.com
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module game::gobang_tests {

    use sui::test_scenario::{Self, Scenario};
    use game::gobang::{Self, Gobang};

    const SEND_MARK_FAILED: u64 = 0;
    const UNEXPECTED_WINNER: u64 = 1;
    const MARK_PLACEMENT_FAILED: u64 = 2;
    const IN_PROGRESS: u8 = 0;
    const W_WIN: u8 = 1;
    const B_WIN: u8 = 2;
    const DRAW: u8 = 3;

    fun place_mark(
        row: u8,
        col: u8,
        player: address,
        scenario: &mut Scenario,
    ): u8  {
        // The gameboard is now a shared object.
        // Any player can place a mark on it directly.
        test_scenario::next_tx(scenario, player);
        let status;
        {
            let game_val = test_scenario::take_shared<Gobang>(scenario);
            let game = &mut game_val;
            gobang::place_mark(game, row, col, test_scenario::ctx(scenario));
            status = gobang::get_status(game);
            test_scenario::return_shared(game_val);
        };
        status
    }

    //     0 1 2 3 4 5 6 7 8 9 a b c d e
    //   + ------------------------------+ 
    // 0 | . . . . . . . . . . . . . . . | 
    // 1 | . . . . . . . . . . . . . . . | 
    // 2 | . . . . . . . . . . . . . . . | 
    // 3 | . . . . . . . . . . . . . . . | 
    // 4 | . . . . . . . . . w . . . . . | 
    // 5 | . . . . . . w . b . . . . . . | 
    // 6 | . . . . . . w b w . . . . . . | 
    // 7 | . . . . . . b w b . . . b . . | 
    // 8 | . . . . . w . w b b w b . . . | 
    // 9 | . . . . w . . . b . b . . . . | 
    // a | . . . . . . . . w b . w . . . | 
    // b | . . . . . . . . b . . . . . . | 
    // c | . . . . . . . w . . . . . . . | 
    // d | . . . . . . . . . . . . . . . | 
    // e | . . . . . . . . . . . . . . . | 
    //   + ------------------------------+
    #[test]
    fun play_gobang_1(){
        let w_player = @0x0;
        let b_player = @0x1;

        let scenario_val = test_scenario::begin(w_player);
        let scenario = &mut scenario_val;
        gobang::create_game(copy w_player, copy b_player, test_scenario::ctx(scenario));

        place_mark(6, 6, w_player, scenario);
        let status = place_mark(7, 6, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);

        place_mark(7, 7, w_player, scenario);
        status = place_mark(6, 7, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);

        place_mark(8, 5, w_player, scenario);
        status = place_mark(8, 8, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);


        place_mark(9, 4, w_player, scenario);
        status = place_mark(5, 8, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);


        place_mark(4, 9, w_player, scenario);
        status = place_mark(7, 8, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);


        place_mark(6, 8, w_player, scenario);
        status = place_mark(8, 9, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);


        place_mark(5, 6, w_player, scenario);
        status = place_mark(9, 10, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);

        place_mark(10, 11, w_player, scenario);
        status = place_mark(8, 11, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);


        place_mark(8, 10, w_player, scenario);
        status = place_mark(9, 8, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);


        place_mark(8, 7, w_player, scenario);
        status = place_mark(11, 8, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);


        place_mark(10, 8, w_player, scenario);
        status = place_mark(10, 9, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);

        place_mark(12, 7, w_player, scenario);
        status = place_mark(7, 12, b_player, scenario);

        assert!(status == B_WIN, 1);
        test_scenario::end(scenario_val);
    }

    //     0 1 2 3 4 5 6 7 8 9 a b c d e
    //   + ------------------------------+ 
    // 0 | . . . . . . . . . . . . . . . | 
    // 1 | . . . . . . . . . . . . . . . | 
    // 2 | . . . . . . . . . . . . . . . | 
    // 3 | . . . . . . . . . . . . . . . | 
    // 4 | . . . . . . . . . w . . . . . | 
    // 5 | . . . . . . . . w . . . . . . | 
    // 6 | . . . . . . b w . . . . . . . | 
    // 7 | . . . . . . w b . . . . . . . | 
    // 8 | . . . . . w . . b . . . . . . | 
    // 9 | . . . . b . . . . . . . . . . | 
    // a | . . . . . . . . . . . . . . . | 
    // b | . . . . . . . . . . . . . . . | 
    // c | . . . . . . . . . . . . . . . | 
    // d | . . . . . . . . . . . . . . . | 
    // e | . . . . . . . . . . . . . . . | 
    //   + ------------------------------+
    #[test]
    fun play_gobang_2(){
        let w_player = @0x0;
        let b_player = @0x1;

        let scenario_val = test_scenario::begin(w_player);
        let scenario = &mut scenario_val;
        gobang::create_game(copy w_player, copy b_player, test_scenario::ctx(scenario));

        place_mark(7, 6, w_player, scenario);
        place_mark(6, 6, b_player, scenario);

        place_mark(6, 7, w_player, scenario);
        place_mark(7, 7, b_player, scenario);

        place_mark(8, 5, w_player, scenario);
        place_mark(9, 4, b_player, scenario);

        place_mark(5, 8, w_player, scenario);
        place_mark(8, 8, b_player, scenario);


        let status = place_mark(4, 9, w_player, scenario);
        assert!(status == W_WIN, 1);
        test_scenario::end(scenario_val);
    }


    //     0 1 2 3 4 5 6 7 8 9 a b c d e
    //   + ------------------------------+ 
    // 0 | w b . . . . . . . . . . . . . | 
    // 1 | w b . . . . . . . . . . . . . | 
    // 2 | w b . . . . . . . . . . . . . | 
    // 3 | w b . . . . . . . . . . . . . | 
    // 4 | w . . . . . . . . . . . . . . | 
    // 5 | . . . . . . . . . . . . . . . | 
    // 6 | . . . . . . . . . . . . . . . | 
    // 7 | . . . . . . . . . . . . . . . | 
    // 8 | . . . . . . . . . . . . . . . | 
    // 9 | . . . . . . . . . . . . . . . | 
    // a | . . . . . . . . . . . . . . . | 
    // b | . . . . . . . . . . . . . . . | 
    // c | . . . . . . . . . . . . . . . | 
    // d | . . . . . . . . . . . . . . . | 
    // e | . . . . . . . . . . . . . . . | 
    //   + ------------------------------+
    #[test]
    fun play_gobang_3(){
        let w_player = @0x0;
        let b_player = @0x1;

        let scenario_val = test_scenario::begin(w_player);
        let scenario = &mut scenario_val;
        gobang::create_game(copy w_player, copy b_player, test_scenario::ctx(scenario));

        place_mark(0, 0, w_player, scenario);
        place_mark(0, 1, b_player, scenario);

        place_mark(1, 0, w_player, scenario);
        place_mark(1, 1, b_player, scenario);

        place_mark(2, 0, w_player, scenario);
        place_mark(2, 1, b_player, scenario);

        place_mark(3, 0, w_player, scenario);
        let status = place_mark(3, 1, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);


        status = place_mark(4, 0, w_player, scenario);
        assert!(status == W_WIN, 1);
        test_scenario::end(scenario_val);
    }

    

    //     0 1 2 3 4 5 6 7 8 9 a b c d e
    //   + ------------------------------+ 
    // 0 | . . . . . . . . . . . . . . . | 
    // 1 | . . . . . . . . . . . . . . . | 
    // 2 | . . . . . . . . . . . . . . . | 
    // 3 | . . . . . . . . . . . . . . . | 
    // 4 | . . . . . . . . . . . . . . . | 
    // 5 | . . . . . . . . . . . . . . . | 
    // 6 | . . . . . . . . . . . . . . . | 
    // 7 | . . . . . . . . . . . . . . . | 
    // 8 | . . . . . . . . . . . . . . . | 
    // 9 | . . . . . . . . . . . . . . . | 
    // a | . . . . . . . . . . w . . . b | 
    // b | . . . . . . . . . . . w . . b | 
    // c | . . . . . . . . . . . . w . b | 
    // d | . . . . . . . . . . . . . w b | 
    // e | . . . . . . . . . . . . . . w | 
    //   + ------------------------------+
    #[test]
    fun play_gobang_4(){
        let w_player = @0x0;
        let b_player = @0x1;

        let scenario_val = test_scenario::begin(w_player);
        let scenario = &mut scenario_val;
        gobang::create_game(copy w_player, copy b_player, test_scenario::ctx(scenario));

        place_mark(14, 14, w_player, scenario);
        place_mark(13, 14, b_player, scenario);

        place_mark(13, 13, w_player, scenario);
        place_mark(12, 14, b_player, scenario);

        place_mark(12, 12, w_player, scenario);
        place_mark(11, 14, b_player, scenario);

        place_mark(11, 11, w_player, scenario);
        let status = place_mark(10, 14, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);


        status = place_mark(10, 10, w_player, scenario);
        assert!(status == W_WIN, 1);
        test_scenario::end(scenario_val);
    }

    //     0 1 2 3 4 5 6 7 8 9 a b c d e
    //   + ------------------------------+ 
    // 0 | . . . . . . . . . . . . . . . | 
    // 1 | . . . . . . . . . . . . . . . | 
    // 2 | . . . . . . . . . . . . . . . | 
    // 3 | . . . . . . . . . . . . . . . | 
    // 4 | . . . . . . . . . . . . . . . | 
    // 5 | . . . . . . . . . . . . . . . | 
    // 6 | . . . . . . . . . . . . . . . | 
    // 7 | . . . . . . . . . . . . . . . | 
    // 8 | . . . . . . . . . . . . . . . | 
    // 9 | . . . . b . . . . . . . . . . | 
    // a | . . . b . . . . . . . . . . . | 
    // b | . . b . w . . . . . . . . . . | 
    // c | . b . w . . . . . . . . . . . | 
    // d | b . w . . . . . . . . . . . . | 
    // e | . w w . . . . . . . . . . . . | 
    //   + ------------------------------+
    #[test]
    fun play_gobang_5(){
        let w_player = @0x0;
        let b_player = @0x1;

        let scenario_val = test_scenario::begin(w_player);
        let scenario = &mut scenario_val;
        gobang::create_game(copy w_player, copy b_player, test_scenario::ctx(scenario));

        place_mark(14, 1, w_player, scenario);
        place_mark(13, 0, b_player, scenario);

        place_mark(13, 2, w_player, scenario);
        place_mark(12, 1, b_player, scenario);

        place_mark(14, 2, w_player, scenario);
        place_mark(11, 2, b_player, scenario);

        place_mark(12, 3, w_player, scenario);
        place_mark(10, 3, b_player, scenario);

        let status = place_mark(11, 4, w_player, scenario);
        assert!(status == IN_PROGRESS, 1);

        status = place_mark(9, 4, b_player, scenario);
        assert!(status == B_WIN, 1);
        test_scenario::end(scenario_val);
    }


    //     0 1 2 3 4 5 6 7 8 9 a b c d e
    //   + ------------------------------+ 
    // 0 | . . . . . . . . . . . . . . . | 
    // 1 | . . . . . . . . . . . . . . . | 
    // 2 | . . . . . . . . . . . . . . . | 
    // 3 | . . . . . . . . . . . . . . . | 
    // 4 | . . . . . . . . . . . . . . . | 
    // 5 | . . . . . . . . . . . . . . . | 
    // 6 | . . . . . . . . . . . . . . . | 
    // 7 | . . . . . . . . . . . . . . . | 
    // 8 | . . . . . . . . . . . . . . . | 
    // 9 | . . . . . . . . . . . . . . . | 
    // a | . . . . . . . . . . . . . . . | 
    // b | . . . . . . . . . . . . . . b | 
    // c | . . . . . . . . . . . . . . b | 
    // d | . . . . . . . . . w w w w w b | 
    // e | . . . . . . . . . . . . . . b | 
    //   + ------------------------------+
    #[test]
    fun play_gobang_6(){
        let w_player = @0x0;
        let b_player = @0x1;

        let scenario_val = test_scenario::begin(w_player);
        let scenario = &mut scenario_val;
        gobang::create_game(copy w_player, copy b_player, test_scenario::ctx(scenario));

        place_mark(13, 13, w_player, scenario);
        place_mark(14, 14, b_player, scenario);

        place_mark(13, 12, w_player, scenario);
        place_mark(13, 14, b_player, scenario);

        place_mark(13, 11, w_player, scenario);
        place_mark(12, 14, b_player, scenario);

        place_mark(13, 10, w_player, scenario);
        let status = place_mark(11, 14, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);
        status = place_mark(13, 9, w_player, scenario);
        assert!(status == W_WIN, 1);
        test_scenario::end(scenario_val);
    }

    //     0 1 2 3 4 5 6 7 8 9 a b c d e
    //   + ------------------------------+ 
    // 0 | . . . . . . . . . . . . b w . | 
    // 1 | . . . . . . . . . . . b w w . | 
    // 2 | . . . . . . . . . . . w b b . | 
    // 3 | . . . . . . . . . . w . . . b | 
    // 4 | . . . . . . . . . w . . . . . | 
    // 5 | . . . . . . . . . . . . . . . | 
    // 6 | . . . . . . . . . . . . . . . | 
    // 7 | . . . . . . . . . . . . . . . | 
    // 8 | . . . . . . . . . . . . . . . | 
    // 9 | . . . . . . . . . . . . . . . | 
    // a | . . . . . . . . . . . . . . . | 
    // b | . . . . . . . . . . . . . . . | 
    // c | . . . . . . . . . . . . . . . | 
    // d | . . . . . . . . . . . . . . . | 
    // e | . . . . . . . . . . . . . . . | 
    //   + ------------------------------+
    #[test]
    fun play_gobang_7(){
        let w_player = @0x0;
        let b_player = @0x1;

        let scenario_val = test_scenario::begin(w_player);
        let scenario = &mut scenario_val;
        gobang::create_game(copy w_player, copy b_player, test_scenario::ctx(scenario));

        place_mark(1, 13, w_player, scenario);
        place_mark(0, 12, b_player, scenario);

        place_mark(0, 13, w_player, scenario);
        place_mark(1, 11, b_player, scenario);

        place_mark(1, 12, w_player, scenario);
        place_mark(2, 12, b_player, scenario);

        place_mark(2, 11, w_player, scenario);
        place_mark(2, 13, b_player, scenario);
        
        place_mark(3, 10, w_player, scenario);
        let status = place_mark(3, 14, b_player, scenario);
        assert!(status == IN_PROGRESS, 1);
        status = place_mark(4, 9, w_player, scenario);
        assert!(status == W_WIN, 1);
        test_scenario::end(scenario_val);
    }

}