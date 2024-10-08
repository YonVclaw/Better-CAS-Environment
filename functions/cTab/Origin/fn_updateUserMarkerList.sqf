/*
	Name: cTab_fnc_updateUserMarkerList

	Author(s):
		Gundy

	Description:
		Update lists of user markers by finding extracting all the user markers with the right encryption key and then translate the marker data in to a format so that it can be drawn quicker.

	Parameters:
		NONE

	Returns:
		BOOLEAN - Always TRUE

	Example:
		call cTab_fnc_updateUserMarkerList;
*/

private _list = [];
{
  private _marker = _x;

  //- Skip on (Prefix "-") or (Marker is already in "_list")
		if (
      _marker select [0,1] == "-"// || 
      // _list findif {_x find _marker > -1} > -1
    ) then {continue};
  
  private _markerShape = MarkerShape _marker;
  private _config = configFile >> "CfgMarkers" >> markerType _marker;

  //- Skip if it's System Marker
		if (_markerShape == "ICON" && getNumber (_config >> "size") == 0) then {continue};

  //- Check if it's Editable
  private _editable = !(_marker find "PLP" > -1) && (
    (_marker find "_cTab" > -1) || 
    (_marker find "_USER" > -1) || 
    (_marker find "mtsmarker" > -1) ||
    (_marker find "SWT_" > -1)
  );

  private _shape = switch (_markerShape) do {
    case "ICON": {0};
    case "RECTANGLE": {1};
    case "ELLIPSE": {2};
    case "POLYLINE": {3};
    default {-1};
  };

  //- _result : [MARKER, SHAPE, DEFAULT_SIZE];
  private _result = if (_marker find "mtsmarker" > -1) then {

    //- Compat for "Metis Marker" (https://steamcommunity.com/sharedfiles/filedetails/?id=1508091616)

    private _prefix = ((_marker splitString "_") # 0) + "_frame";
    private _search = _list findif {
      (_x # 0) find _prefix > -1
    };
    private _index = [_forEachIndex,_search] select (_search > -1);

    [
      _marker,
      _index,
      _shape,
      getNumber (_config >> "size"),
      _editable
    ]
  } else {
    [_marker, _forEachIndex, _shape,0,_editable]
  };
  
  _list pushBack _result;
} forEach allMapMarkers;

cTabUserMarkerList = _list;

["ctab_userMarkerListUpdated"] call CBA_fnc_localEvent;

true