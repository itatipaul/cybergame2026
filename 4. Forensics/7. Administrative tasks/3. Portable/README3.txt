If you want to get flag encrypted in flag3.zip you need to get password!

In the file PBES-512.pdf are hidden 4 parts needed to get create password. 

All parts are in format HIDDEN_MSG_x_{something}

To get final password you need to find all 4 parts and then take their contents to construct password: 


|=======================|
|The exact order is 4321|
|=======================|


Example: 

	HIDDEN_MSG_1_{aaaaaaaa}
	HIDDEN_MSG_2_{bbbbbbbb}
	HIDDEN_MSG_3_{cccccccc}
	HIDDEN_MSG_4_{dddddddd}

	If given order is 1423 what you have order hidden messages contents by number:
		
		FLAG_PASSWORD = MSG_1 + MSG_4 + MSG_2 + MSG_3

		FLAG_PASSWORD = "aaaaaaaa" + "dddddddd" + "bbbbbbbb" + "cccccccc"

		FLAG_PASSWORD = "aaaaaaaaddddddddbbbbbbbbcccccccc"

