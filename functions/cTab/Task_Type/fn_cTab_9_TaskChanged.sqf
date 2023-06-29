//if (_curLine in [2,3,4]) then {_clearbut ctrlShow false};

switch _curLine do {
  //-Game Plan
  case 0:{
    _shownCtrls params [
      "_title_ctrl","_ctrl",
      "_title_type","_type",
      "_ord_title",
      "_weap","_mode","_range","_count"
    ];
    _taskVar_0 = _taskVar # 0;

    //-Weapon List
    [ctrlParent _weap,_weap,player getVariable ['TGP_View_Selected_Vehicle',objNull],false,false,false] call BCE_fnc_checkList;

    //-Default
    if ((_taskVar_0 # 0) != "NA") then {
      _taskVarSel = _taskVar_0 # 4;
      _ctrl lbSetCurSel (_taskVarSel # 0);
      _type lbSetCurSel (_taskVarSel # 1);
      _weap lbSetCurSel (_taskVarSel # 2);
      _mode lbSetCurSel (_taskVarSel # 3);
      _range lbSetCurSel (_taskVarSel # 4);
      _count ctrlSetText (_taskVarSel # 5);
    } else {
      _ctrl lbSetCurSel 0;
      _type lbSetCurSel 0;
      _weap lbSetCurSel (lbCurSel _checklist);
    };

    _ctrlPOS = ctrlPosition _ctrl;
    _weapPOS = ctrlPosition _weap;
    _modePOS = ctrlPosition _mode;
    _rangePOS = ctrlPosition _range;

    //-Expression
    _mode ctrlSetPosition
    [
      (_weapPOS # 0) + (_modePOS # 2),
      _weapPOS # 1,
      _weapPOS # 2,
      _weapPOS # 3
    ];
    _count ctrlSetPosition
    [
      (_weapPOS # 0) + (_modePOS # 2),
      _rangePOS # 1,
      _rangePOS # 2,
      _rangePOS # 3
    ];
    _mode ctrlCommit 0;
    _count ctrlCommit 0;
  };

  //-IP/BP
  case 1:{
    _shownCtrls params ["_ctrl1","_ctrl2","_ctrl3"];
    _taskVar_1 = _taskVar # 1;

    //-Back to previous status
    if ((_taskVar_1 # 0) != "NA") then {
      _ctrl1 lbSetCurSel (_taskVar_1 # 3 # 0);
      _ctrl2 lbSetCurSel (_taskVar_1 # 3 # 1);
    };

    _ctrl1sel = lbCurSel _ctrl1;
    _ctrl3 ctrlSetText (_taskVar_1 # 0);

    if (_ctrl1sel == 0) then {
      _ctrl2 ctrlShow true;
      _ctrl2 call BCE_fnc_IPMarkers;
    } else {
      _ctrl2 ctrlShow false;
    };

    _ctrl2POS = ctrlPosition _ctrl2;
    _ctrl3POS = ctrlPosition _ctrl3;

    //-Expression
    _ctrl3 ctrlSetPosition
    [
      (_ctrl2POS # 0) + (_ctrl2POS # 2),
      _ctrl2POS # 1,
      _ctrl2POS # 2,
      _ctrl2POS # 3
    ];
    _ctrl3 ctrlCommit 0;
  };

  //-GRID
  case 6:{
    _shownCtrls params ["_ctrl1","_ctrl2","_ctrl3"];
    _taskVar_6 = _taskVar # 6;

    //-Back to previous status
    if ((_taskVar_6 # 0) != "NA") then {
      _ctrl1 lbSetCurSel (_taskVar_6 # 3 # 0);
      _ctrl2 lbSetCurSel (_taskVar_6 # 3 # 1);
    };

    _ctrl1sel = lbCurSel _ctrl1;
    _ctrl3 ctrlSetText (_taskVar_6 # 0);

    if (_ctrl1sel == 0) then {
      _ctrl2 ctrlShow true;
      _ctrl2 call BCE_fnc_IPMarkers;
    } else {
      _ctrl2 ctrlShow false;
    };

    _ctrl2POS = ctrlPosition _ctrl2;
    _ctrl3POS = ctrlPosition _ctrl3;

    //-Expression
    _ctrl3 ctrlSetPosition
    [
      (_ctrl2POS # 0) + (_ctrl2POS # 2),
      _ctrl2POS # 1,
      _ctrl2POS # 2,
      _ctrl2POS # 3
    ];
    _ctrl3 ctrlCommit 0;
  };

  //-MARK
  case 7:{
    _shownCtrls params ["_ctrl"];
    private _taskVar7 = _taskVar # 7;
    private _ctrlPOS = ctrlPosition _ctrl;

    _ctrl ctrlSetText (["Mark with...",(_taskVar # 7 # 1)] select ((_taskVar7 # 0) != "NA"));

    _ctrl ctrlSetPosition
    [
      _ctrlPOS # 0,
      (_titlePOS # 1) + (_titlePOS # 3),
      _ctrlPOS # 2,
      _ctrlPOS # 3
    ];
    _ctrl ctrlCommit 0;
  };

  //-Friendlies
  case 8:{
    _shownCtrls params ["_ctrl1","_ctrl2","_ctrl3","_ctrl4"];
    private [
      "_taskVar_8","_InfoText","_isEmptyInfo","_Info","_ctrl1sel",
      "_ctrl2POS","_ctrl3POS","_ctrl4POS"
    ];
    _taskVar_8 = _taskVar # 8;
    _InfoText = _taskVar_8 # 4;
    _isEmptyInfo = ((_InfoText == "Mark with...") or (_InfoText == ""));

    _Info = [format ["with :[%1]",_taskVar_8 # 4],"Mark with..."] select _isEmptyInfo;

    //-Back to previous status
    if ((_taskVar_8 # 0) != "NA") then {
      _ctrl1 lbSetCurSel (_taskVar_8 # 3 # 0);
      _ctrl2 lbSetCurSel (_taskVar_8 # 3 # 1);
      _ctrl4 ctrlSetText _Info;
    } else {
      _ctrl4 ctrlSetText "Mark with...";
    };

    _ctrl1sel = lbCurSel _ctrl1;
    _ctrl3 ctrlSetText (_taskVar_8 # 0);

    if (_ctrl1sel == 0) then {
      _ctrl2 ctrlShow true;
      _ctrl2 call BCE_fnc_IPMarkers;
    } else {
      _ctrl2 ctrlShow false;
    };

    _ctrl2POS = ctrlPosition _ctrl2;
    _ctrl3POS = ctrlPosition _ctrl3;
    _ctrl4POS = ctrlPosition _ctrl4;

    //-Expression
    _ctrl3 ctrlSetPosition
    [
      (_ctrl2POS # 0) + (_ctrl2POS # 2),
      _ctrl2POS # 1,
      _ctrl2POS # 2,
      _ctrl2POS # 3
    ];
    _ctrl3 ctrlCommit 0;

    _ctrl4 ctrlSetPosition
    [
      _ctrl2POS # 0,
      (_ctrl2POS # 1) + (_ctrl2POS # 3),
      _ctrl4POS # 2,
      _ctrl4POS # 3
    ];
    _ctrl4 ctrlCommit 0;
  };

  //-EGRS [Toolbox, EditBox, output, Toolbox(Azimuth), Marker(combo)]
  case 9:{
    _shownCtrls params ["_ctrl1","_ctrl2","_ctrl3","_ctrl4","_ctrl5"];
    _taskVar_9 = _taskVar # 9;

    //-Back to previous status
    if ((_taskVar_9 # 0) != "NA") then {
      _ctrl1 lbSetCurSel (_taskVar_9 # 2 # 0);
      _ctrl4 lbSetCurSel (_taskVar_9 # 2 # 1);
      _ctrl5 lbSetCurSel (_taskVar_9 # 2 # 2);

      _ctrl2 ctrlSetText (str (_taskVar_9 # 1));
    } else {
      _ctrl2 ctrlSetText "Bearing...";
    };

    _ctrl1sel = lbCurSel _ctrl1;
    _ctrl3 ctrlSetText (_taskVar_9 # 0);

    if (_ctrl1sel == 0) then {
      _ctrl2 ctrlShow false;
      _ctrl5 ctrlShow false;

      _ctrl4 ctrlShow true;
    } else {
      //-Map Markers
      if (_ctrl1sel == 2) then {
        _ctrl5 ctrlShow true;
        _ctrl5 call BCE_fnc_IPMarkers;

        _ctrl2 ctrlShow false;
        _ctrl4 ctrlShow false;
      } else {
        _ctrl5 ctrlShow false;

        _ctrl2 ctrlShow true;
        _ctrl4 ctrlShow false;
      };
    };

    _ctrl2POS = ctrlPosition _ctrl2;
    _ctrl3POS = ctrlPosition _ctrl3;

    //-Expression
    _ctrl3 ctrlSetPosition
    [
      (_ctrl2POS # 0) + (_ctrl2POS # 2),
      _ctrl2POS # 1,
      _ctrl2POS # 2,
      _ctrl2POS # 3
    ];
    _ctrl3 ctrlCommit 0;
  };

  //-Remarks
  case 10:{
    //-FAD/H [Toolbox, EditBox, output, Toolbox(Azimuth), DanClose(Text), DanClose(Box)]
    _shownCtrls params ["_ctrl1","_ctrl2","_ctrl3","_ctrl4","_ctrl5","_ctrl6"];

    _taskVar_10 = _taskVar # 10;

    //-Back to previous status
    if ((_taskVar_10 # 0) != "NA") then {
      (_taskVar_10 # 2) params [["_cndtion1",0],["_cndtion2",0],["_cndtion3",false]];
      _ctrl1 lbSetCurSel _cndtion1;
      _ctrl4 lbSetCurSel _cndtion2;
      _ctrl6 cbSetChecked _cndtion3;

      if ((_taskVar_10 # 1) != -1) then {
        _ctrl2 ctrlSetText (str (_taskVar_10 # 1));
      };
    } else {
      _ctrl2 ctrlSetText "Bearing...";
    };

    _ctrl1sel = lbCurSel _ctrl1;
    _ctrl3 ctrlSetText (_taskVar_10 # 0);

    if (_ctrl1sel == 2) then {
      _ctrl4 ctrlShow false;
      _ctrl2 ctrlShow false;
    } else {
      //-FA D/H
      if (_ctrl1sel == 0) then {
        _ctrl2 ctrlShow false;
        _ctrl4 ctrlShow true;
      } else {
        _ctrl2 ctrlShow true;
        _ctrl4 ctrlShow false;
      };
    };

    _ctrl2POS = ctrlPosition _ctrl2;
    _ctrl3POS = ctrlPosition _ctrl3;

    //-Expression
    _ctrl3 ctrlSetPosition
    [
      (_ctrl2POS # 0) + (_ctrl2POS # 2),
      _ctrl2POS # 1,
      _ctrl2POS # 2,
      _ctrl2POS # 3
    ];
    _ctrl3 ctrlCommit 0;
  };
};
