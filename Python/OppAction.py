# OppAction class

"""   
    @ Language : Python 3.5.2
    @ Author   : Ahmed Mustafa

    - Data Members:
        * ptype : my player type : 0 = red , 1 = blue
        * action : enum
        * force
        * ball_sequence array of size 5
        * isTimeEvent
        * seq_iter : ball_sequence array iterator
                
    - Methods\Functions:
        * Translate : decoding comm. output
        * _Translate_kick : for internal use
        * p : print data - for testing

    - Action Enum:
       0  : init (don't care)
       1  : kick forward
       2  : kick left diagonal
       3  : kick right diagonal
       4-6: move (don't care)
       8  : no action (don't care)

"""
# Import classes
from utility_classes.Environment import Environment
from utility_classes.Position import Position
from copy import copy

class OppAction:

    def __init__(self, player_type):
        self.action = 0
        self.force = 0
        self.isTimeEvent = False
        self.ptype = player_type
        self.seq_iter = 0
        self.ball_sequence = []
        x = Position(5,3) #ball starts at (5,3)
        for i in range(5): 
            self.ball_sequence.append(copy(x))
        
    ####################################################################################################################### 
    
    def Translate(self, CommString, Env):
        """
         - Input :
            * string from comm.
            * env

        - Output :
            N/A
        """
        # init.
        self.isTimeEvent = False
        direction = 0

        arr = CommString.split(' ')

        # check comm input
        """ if move up or down, neglect
            if no action, neglect
            also rod_number is neglected
        """
        if(CommString == "new_step"):
            """ update isTimeEvent & seq_iter """
            self.isTimeEvent = True
            self.seq_iter += 1
          
        elif(arr[0] == "kick"):
            """ update force & seq_iter """
            self.force = ord(arr[2])-ord('0')

            if(arr[3] == "-1"):
                direction = -1
            else:
                direction = ord(arr[3]) - ord('0')

            self._Translate_kick(direction, Env)
            self.seq_iter = 0

        
    #######################################################################################################################
        
    def _Translate_kick(self, direction, Env):
        """ for internal use """

        """ (update action) Convert communication direction to action enum """
        if(direction == 0): #straight
            self.action = 1 #kick forward

        elif((self.ptype == 0 and direction == 1) or (self.ptype == 1 and direction == -1)): #red & up or blue & down
            self.action = 2 #kick left diagonal

        elif((self.ptype == 0 and direction == -1) or (self.ptype == 1 and direction == 1)): #red & down or blue & up
            self.action = 3 #kick right diagonal


        """ update ball_sequence """

        for i in range(5):
            self.ball_sequence[i].x = Env.ball.x
            self.ball_sequence[i].y = Env.ball.y
    
        sign = 1
        if(self.ptype == 1): #blue
            sign = -1
        step = 1
        if(direction == 0): #straight
            #increment until force
            for i in range(self.force):
                self.ball_sequence[i].x = self.ball_sequence[i].x + step*sign
                step += 1

        elif(direction == 1): #up
            #increment until force
            for i in range(0,self.force):
                self.ball_sequence[i].x += step*sign
                self.ball_sequence[i].y += step
                step += 1

        elif(direction == -1): #down
            #increment until force
            for i in range(0,self.force):
                self.ball_sequence[i].x += step*sign
                self.ball_sequence[i].y -= step
                step += 1

        
        #update the rest with last position
        for i in range(self.force,5):
            self.ball_sequence[i].x = self.ball_sequence[i-1].x
            self.ball_sequence[i].y = self.ball_sequence[i-1].y


    #######################################################################################################################

    def p(self):
        """ to print data - for testing """
        print("Player type :",self.ptype)
        print("Action :",self.action)
        print("force :",self.force)
        print("ball seq:")
        for i in range(5):
            print("\t ",self.ball_sequence[i].x,",",self.ball_sequence[i].y)
        print("ball seq iterator =",self.seq_iter)
        print("time event?",self.isTimeEvent)
        print("__________________________________________")
