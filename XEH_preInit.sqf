#include "CBA_Setting.hpp"
#include "\MG8\AVFEVFX\cTab\has_cTab.hpp"

//-All Infos from types of task list
if (hasInterface) exitWith {
  //-Set task default variables
  [
    ["BCE_CAS_9Line_Var", [["NA",0],["NA","",[],[0,0]],["NA",180],["NA",200],["NA",15],["NA","--"],["NA","",[],[0,0],[]],["NA","1111"],["NA","",[],[0,0],""],["NA",0,[],nil,nil],["NA",-1,[]]]],
    ["BCE_CAS_5Line_Var", [["NA",0],["NA","",[],[0,0],""],["NA","111222"],["NA","--",""],["NA",-1,[]]]]
  ] apply {
    uiNamespace setVariable _x
  };

  //-Set All IDCs
  private _set_TaskBuilder_Vars = {
  	params ["_config",["_offset",0]];

  	private _classes = ["CAS_TaskList_9","CAS_TaskList_5"] apply {
  		"true" configClasses (_config >> "controls" >> _x >> "items");
  	};

  	[
  		(_classes apply {
  			_x apply {
  				getArray (_x >> "Expression_idc") apply {_x + _offset}
  			}
  		}),
  		(_classes apply {
  			_x apply {
  				[getText (_x >> "textRight"), getText (_x >> "Task_writeDown")]
  			}
  		})
  	]
  };

  //-Set all Task IDCs
  AVT_Task_TaskItems = (configFile >> "RscDisplayAVTerminal") call _set_TaskBuilder_Vars;

  #ifdef cTAB_Installed
    cTab_Task_TaskItems = [configFile >> "cTab_Tablet_dlg" >> "controls" >> "Task_Builder",17000] call _set_TaskBuilder_Vars;
    
    private _condition = "!(getNumber (_x >> 'IDC') in [-1,17000 + 2107,17000 + 2011,17000 + 20112,17000 + 2020,17000 + 2021,17000 + 2022,17000 + 2023,17000 + 2024])";
    private _classes = _condition configClasses (configFile >> "cTab_Android_dlg" >> "controls" >> "Task_Builder" >> "controls");
    ATAK_Task_Items = _classes apply {
      private ["_idc"];
      _idc = getNumber(_x >> "IDC");
    };
    
    
    //- Set Default Devices
    ctab_core_personneldevices = ["ItemcTab","ItemAndroid","ItemMicroDAGR"];
    ctab_core_leaderDevices = ["ItemcTab","ItemAndroid"];
  #endif
};
