/*
	'DomPool' Online Multiplayer Dominoes Game - code sample
	(Node.JS)
*/

$(document).ready(function (){
    
    // when the page is loaded, call page_start() function
    window.onload = page_start;

    /*
        When a card is played:
        1- check if it's an existed valid card in my turn (with my data)
        2- if error, message to user
        3- if no error, calculate side
        4- if both sides are valid, get input from user
        5- calculate position
        6- send to the server to check
    */
    $(document).delegate('.cardbutton', 'click', function (){
        
        // 1- check if it's an existed valid card in my turn (with my data)
        var ID = parseInt($(this).attr("id"));
        currentVAL = parseInt($(this).attr("value"));
        console.log(currentVAL);

        if (!(my_cards_valid[ID] && my_cards[ID] == currentVAL && my_turn))
        {
            // 2- if error, message to user
            alert("Wrong Play");
            return;
        }

        // 3- if no error, calculate side
        check_side();
        
        // 4- if both sides are valid, get input from user
        if (side == 3)
        {
            $("#" + right_id).addClass('side-button');
            $("#" + left_id).addClass('side-button');

            msg_choose_side();

            return;
        }

        // 5- calculate position
        check_position();

        // 6- send to the server to check
        var svalue = left;
        if(side == 2)
            svalue = right;
        socket.emit('tile_is_played', [currentVAL, svalue, side]);

        console.log('/////////////////tile is played msg :' + currentVAL + ' ' + svalue + ' ' + side);
        printAll();
    });

    $(document).delegate('.drawcard', 'click', function () {

        if (my_turn == 1 && need_extra)
        {
            socket.emit('get_extra_tile');
            console.log('Drawcard sent to server');
        }
                    
        console.log('//////////////////////////////////////////////////Drawcard function');
        printAll();

    });

    $(document).delegate('.new_round_button', 'click', function () {

        if (round_end)
            socket.emit('New_Round');
                        
        console.log('//////////////////////////////////////////////////Start new round function');
        printAll();

    });

    $(document).delegate('.new_match_button', 'click', function () {

        if (match_end)
        {
            socket.emit('New_Game');
            console.log('start new game sent');
        }
            
        console.log('//////////////////////////////////////////////////Start new match function');
        printAll();

    });

    $(document).delegate('.side-button', 'click', function () {

        // Reset
        $("#" + right_id).removeClass('side-button');
        $("#" + left_id).removeClass('side-button');
        clear_msg();

        // determine side
        var ID = parseInt($(this).attr("id"));

        if (ID == right_id)
            side = 2;
        else if (ID == left_id)
            side = 1;
        else
            alert('Something wrong!!');

        // calculate position
        check_position();

        // send to the server to check
        var svalue = left;
        if (side == 2)
            svalue = right;

        socket.emit('tile_is_played', [currentVAL, svalue, side]);

        console.log('//////////////tile is played (side) msg :' + currentVAL + ' ' + svalue + ' ' + side);
        
        printAll();

    });

    $(document).delegate('.pass_button', 'click', function () {

        socket.emit('i_cannot_play');
        clear_msg();

        console.log('//////////////////////////////////////////////////pass_button function');
        printAll();

    });

});
