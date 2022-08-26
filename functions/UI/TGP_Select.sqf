#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\A3\ui_f\hpp\defineCommonGrids.inc"

params ["_mode", "_params"];

_display = _params # 0;
_ctrlValue = _display displayctrl IDC_RSCATTRIBUTECAS_VALUE;
_vehicle = objNull;

_UnitList = vehicles select {
  !(_x getVariable "TGP_View_Available_Optics" isEqualTo []) && (isEngineOn _x)
};

switch _mode do {
	case "onLoad": {
		_ctrlValue ctrlsetfontheight GUI_GRID_H;
		_selected = player getvariable ["TGP_View_Selected_Vehicle",objNull];

    _BluFriendly = [playerSide, West] call BIS_fnc_sideIsFriendly;
    _RedFriendly = [playerSide, east] call BIS_fnc_sideIsFriendly;
    _GreFriendly = [playerSide, resistance] call BIS_fnc_sideIsFriendly;

		{
      _vehicle = _x;
			_class = typeOf _vehicle;
			_cfg = configfile >> "cfgvehicles" >> _class;
      _vehicleSide = side _vehicle;

      _west = if (_BluFriendly) then {_vehicleSide == West} else {false};
      _east = if (_RedFriendly) then {_vehicleSide == east} else {false};
      _green = if (_GreFriendly) then {_vehicleSide == resistance} else {false};

			if (_west or _east or _green) then {
        _lnbAdd = if (_selected isEqualTo _vehicle) then {
          _ctrlValue lnbaddrow ["","",format ["* %1     %2",Name _vehicle,gettext (_cfg >> "displayName")]];
        } else {
          _ctrlValue lnbaddrow ["","",format ["%1     %2",Name _vehicle,gettext (_cfg >> "displayName")]];
        };
				_ctrlValue lnbsetdata [[_lnbAdd,0],str _vehicle];
				_ctrlValue lnbsetpicture [[_lnbAdd,0],gettext (configfile >> "cfgfactionclasses" >> gettext (_cfg >> "faction") >> "icon")];
				_ctrlValue lnbsetpicture [[_lnbAdd,1],gettext (_cfg >> "picture")];
			};
		} foreach _UnitList;

    _ctrlValue lnbsort [2,false];

		for "_i" from 0 to ((lnbsize _ctrlValue # 0) - 1) do {
			if ((_ctrlValue lnbdata [_i,0]) == "") exitwith {_ctrlValue lnbsetcurselrow _i;};
		};
		if (lnbcurselrow _ctrlValue < 0) then {
			_ctrlValue lnbsetcurselrow 0;
		};
	};
	case "confirmed": {
    _vehicle_str = _ctrlValue lnbdata [lnbcurselrow _ctrlValue,0];

    {
      if (_vehicle_str == str _x) exitWith {_vehicle = _x};
    } count _UnitList;
    player setVariable ["TGP_View_Selected_Vehicle",_vehicle];
    _vehicle call BCE_fnc_TGP_Select_Confirm;
	};
	case "onUnload": {
		if (!isnil "RscAttributePostProcess_default") then {
			[nil,0,false] call bis_fnc_setPPeffectTemplate;
		};
		RscAttributePostProcess_default = nil;
	};
};
