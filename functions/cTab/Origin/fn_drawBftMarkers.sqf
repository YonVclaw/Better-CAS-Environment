/*
 	Name: cTab_fnc_drawBftMarkers

 	Author(s):
		Gundy, Riouken

		Edit: Aaren

 	Description:
		Draw BFT markers

		List format:
			Index 0: Unit object
			Index 1: Path to icon A
			Index 2: Path to icon B (either group size or wingmen)
			Index 3: Text to display
			Index 4: String of group index


	Parameters:
		0: OBJECT	- Map control to draw BFT icons on
		1: INTEGER - Mode, 0 = draw normal, 1 = draw for TAD, 2 = draw for MicroDAGR

 	Returns:
		BOOLEAN - Always TRUE

 	Example:
		[_ctrlScreen,0] call cTab_fnc_drawBftMarkers;
*/
params ["_ctrlScreen","_mode"];
private ["_ctrlScreen","_mode","_veh","_iconB","_groupID","_vehicles","_vehIndex","_mountedLabels","_mountedIndex","_drawText","_playerVehicle","_playerGroup","_teamColor"];

_vehicles = [];
_playerVehicle = vehicle cTab_player;
_playerGroup = group cTab_player;
_mountedLabels = [];
_drawText = cTabBFTtxt;
_Connected_veh = cTab_player getvariable ["TGP_View_Selected_Vehicle",objNull];
_PointedIndex = [_ctrlScreen,cTabMapCursorPos] call cTab_fnc_findUserMarker;

// Anything but MicroDAGR
if (_mode != 2) then {
	// ------------------ VEHICLES ------------------
	_i = 0;
	cTabBFTvehicles apply {
		_x params ["_veh","_iconA","_iconB","_text","_groupID"];

		private _pos = getPosASLVisual _veh;
		if !(_drawText) then {_text = ""};

		call {
			if (_mode == 1 && {_iconB != "" && {_veh != _playerVehicle}}) exitWith {
				// Drawing on TAD && vehicle is an air contact
				call {
					if (_groupID != "") exitWith {
						// air contact is in our group
						_ctrlScreen drawIcon [_iconB,cTabTADgroupColour,_pos,cTabAirContactSize,cTabAirContactSize,direction _veh,"",0,cTabTxtSize,"TahomaB","right"];
						_ctrlScreen drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",cTabTADgroupColour,_pos,0,0,0,_groupID,0,cTabAirContactGroupTxtSize * 0.8,"TahomaB","center"];
					};
					// air contact is _not_ in our group
					_ctrlScreen drawIcon [_iconB,cTabTADfontColour,_pos,cTabAirContactSize,cTabAirContactSize,direction _veh,"",0,cTabTxtSize,"TahomaB","right"];
					if (_drawText) then {
						_ctrlScreen drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",cTabTADfontColour,_pos,cTabAirContactDummySize,cTabAirContactDummySize,0,_text,0,cTabTxtSize,"TahomaB","right"];
					};
				};
			};
			// Draw on anything but TAD
			call {
				if (_veh != _playerVehicle) exitWith {
					private _color =[
						cTabColorBlue,
						[1,1,0.3,0.8]
					] select (_Connected_veh == _veh);

					//-if it's pointed vehicle
					if (_veh isEqualTo _PointedIndex) then {_color = cTabTADhighlightColour};

					// player is not sitting in this vehicle
					_ctrlScreen drawIcon [_iconA,_color,_pos,cTabIconSize,cTabIconSize,0,_text,0,cTabTxtSize,"TahomaB","right"];
				};
				if (group _veh != _playerGroup) then {
					// player is not in the same group as this vehicle
					_ctrlScreen drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",cTabColorBlue,_pos,cTabIconSize,cTabIconSize,0,_text,0,cTabTxtSize,"TahomaB","right"];
				};
			};
		};
		0 = _vehicles pushBack _veh;
		_i = _i + 1;
	};

	// ------------------ GROUPS ------------------
	cTabBFTgroups apply {
		private _veh = vehicle (_x # 0);

		call {
			// See if the group leader's vehicle is in the list of drawn vehicles
			private _vehIndex = _vehicles find _veh;
			private _text = _x # 3;

			// Only do this if the vehicle has not been drawn yet, or the player is sitting in the same vehicle as the group leader
			if (_vehIndex != -1 || {_veh == _playerVehicle}) exitWith {
				if (_drawText) then {
					// we want to draw text and the group leader is in a vehicle that has already been drawn
					// _vehIndex == -1 means that the player sits in the vehicle
					if (_vehIndex == -1 || {(groupID group _veh) != _text}) then {
						// group name is not the same as that of the vehicle the leader is sitting in
						_mountedIndex = _mountedLabels find _veh;
						if (_mountedIndex != -1) then {
							_mountedLabels set [_mountedIndex + 1,(_mountedLabels # (_mountedIndex + 1)) + "/" + (_text)];
						} else {
							0 = _mountedLabels pushBack _veh;
							0 = _mountedLabels pushBack _text;
						};
					};
				};
			};
			private _pos = getPosASLVisual _veh;
			_ctrlScreen drawIcon [_x # 1,cTabColorBlue,_pos,cTabIconSize,cTabIconSize,0,_text,0,cTabTxtSize,"TahomaB","right"];
			_ctrlScreen drawIcon [_x # 2,cTabColorBlue,_pos,cTabGroupOverlayIconSize,cTabGroupOverlayIconSize,0,"",0,cTabTxtSize,"TahomaB","right"];
		};
	};
};

// ------------------ MEMBERS ------------------
cTabBFTmembers apply {
	private ["_veh","_pos"];
	_veh = vehicle (_x # 0);
	_pos = getPosASLVisual _veh;

	call {
		// make sure we are still in the same team
		if (group cTab_player != group (_x # 0)) exitWith {};

		// get the fire-team color
		private _teamColor = cTabColorTeam # (["MAIN","RED","GREEN","BLUE","YELLOW"] find (assignedTeam (_x # 0)));

		if (_mode != 2 && {_veh == _playerVehicle || {_veh in _vehicles}}) exitWith {
			if (_drawText) then {
				// we want to draw text on anything but MicroDAGR and the unit sits in a vehicle that has already been drawn
				_mountedIndex = _mountedLabels find _veh;
				if (_mountedIndex != -1) then {
					_mountedLabels set [_mountedIndex + 1,(_mountedLabels # (_mountedIndex + 1)) + "/" + (_x # 4)];
				} else {
					0 = _mountedLabels pushBack _veh;
					0 = _mountedLabels pushBack (_x # 4);
				};
			};
		};
		if (_veh != (_x # 0)) exitWith {
			// the unit _does_ sit in a vehicle
			_mountedIndex = _mountedLabels find _veh;
			if (_mountedIndex != -1 && _drawText) then {
				_mountedLabels set [_mountedIndex + 1,(_mountedLabels # (_mountedIndex + 1)) + "/" + (_x # 4)];
			} else {
				0 = _mountedLabels pushBack _veh;
				if	(_drawText) then {
					0 = _mountedLabels pushBack (_x # 4);
				};
				if (_veh != _playerVehicle) then {
					_ctrlScreen drawIcon ["\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",cTabColorBlue,_pos,cTabIconSize,cTabIconSize,direction _veh,"",0,cTabTxtSize,"TahomaB","right"];
				};
			};
		};
		_ctrlScreen drawIcon [_x # 1,_teamColor,_pos,cTabIconManSize,cTabIconManSize,direction _veh,"",0,cTabTxtSize,"TahomaB","right"];
		if (_drawText) then {
			_ctrlScreen drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",_teamColor,_pos,cTabIconManSize,cTabIconManSize,0,_x # 4,0,cTabTxtSize,"TahomaB","right"];
		};
	};
};

// ------------------ ADD LABEL TO VEHICLES WITH MOUNTED GROUPS / MEMBERS ------------------
if (_drawText && !(_mountedLabels isEqualTo [])) then {
	for "_i" from 0 to (count _mountedLabels - 2) step 2 do {
		private _veh = _mountedLabels # _i;
		if (_veh != _playerVehicle) then {
			_ctrlScreen drawIcon ["\A3\ui_f\data\map\Markers\System\dummy_ca.paa",cTabColorBlue,_pos,cTabIconSize,cTabIconSize,0,_mountedLabels # (_i + 1),0,cTabTxtSize,"TahomaB","left"];
		};
	};
};

true
