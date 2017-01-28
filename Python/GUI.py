# GUI class

"""   
    @ Language : Python 3.5.2
    @ Author   : Ahmed Mustafa

    - This class is responsible for:
        * updating GUI by sending the Environment object to JS client via JSON file

    - Data Members:
        N/A
                
    - Methods\Functions:
        * update_GUI(Environment)

"""

# Import classes
from Environment import Environment
import json

class GUI:

    
    def update_GUI(self,Env):
        """
          Convert the Environment object to JSON format then write it in "GUIdata.json"
          Input  : Environment object
          Output : N/A
        """

        # organize the data
        myrod1p1 = (Env.MyRod_1.p_1.x, Env.MyRod_1.p_1.y)
        myrod1p2 = (Env.MyRod_1.p_2.x, Env.MyRod_1.p_2.y)
        myrod1p3 = (Env.MyRod_1.p_3.x, Env.MyRod_1.p_3.y)
        
        myrod2p1 = (Env.MyRod_2.p_1.x, Env.MyRod_2.p_1.y)
        myrod2p2 = (Env.MyRod_2.p_2.x, Env.MyRod_2.p_2.y)
        myrod2p3 = (Env.MyRod_2.p_3.x, Env.MyRod_2.p_3.y)

        oprod1p1 = (Env.OpponentRod_1.p_1.x, Env.OpponentRod_1.p_1.y)
        oprod1p2 = (Env.OpponentRod_1.p_2.x, Env.OpponentRod_1.p_2.y)
        oprod1p3 = (Env.OpponentRod_1.p_3.x, Env.OpponentRod_1.p_3.y)

        oprod2p1 = (Env.OpponentRod_2.p_1.x, Env.OpponentRod_2.p_1.y)
        oprod2p2 = (Env.OpponentRod_2.p_2.x, Env.OpponentRod_2.p_2.y)
        oprod2p3 = (Env.OpponentRod_2.p_3.x, Env.OpponentRod_2.p_3.y)

        ball = (Env.ball.x, Env.ball.y)

        # convert to JSON object
        data = [{
          'ball'  :  ball,
          'myrod1': {'p1':myrod1p1, 'p2':myrod1p2, 'p3':myrod1p3 },
          'myrod2': {'p1':myrod2p1, 'p2':myrod2p2, 'p3':myrod2p3 },
          'oprod1': {'p1':oprod1p1, 'p2':oprod1p2, 'p3':oprod1p3 },
          'oprod2': {'p1':oprod2p1, 'p2':oprod2p2, 'p3':oprod2p3 }
        }]

        # save it in "GUIdata.json" file
        json.dump(data, open('GUIdata.json', 'w'))


