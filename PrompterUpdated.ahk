

;     888                                                               888  888   888888888   .d8888b.   .d8888b.   d888   
;     888                                                               888  888   888        d88P  Y88b d88P  Y88b d8888   
;     888                                                             888888888888 888        888        888    888   888   
; .d88888  8888b.  88888b.   .d88b.   .d88b.  88888b.   .d88b.  888d888 888  888   8888888b.  888d888b.  888    888   888   
;d88" 888     "88b 888 "88b d88""88b d88""88b 888 "88b d8P  Y8b 888P"   888  888        "Y88b 888P "Y88b 888    888   888   
;888  888 .d888888 888  888 888  888 888  888 888  888 88888888 888   888888888888        888 888    888 888    888   888   
;Y88b 888 888  888 888 d88P Y88..88P Y88..88P 888 d88P Y8b.     888     888  888   Y88b  d88P Y88b  d88P Y88b  d88P   888   
; "Y88888 "Y888888 88888P"   "Y88P"   "Y88P"  88888P"   "Y8888  888     888  888    "Y8888P"   "Y8888P"   "Y8888P"  8888888 
;                  888                        888                                                                           
;                  888                        888                                                                           
;                  888                        888                                                                           


#NoEnv  
SendMode Input  
SetWorkingDir %A_ScriptDir% 
#SingleInstance,Force
SetBatchLines, -1

CusResCounter := 0

DefaultFile =
(
[SavedSection]
MainList=
AutoList=
AutoDelay=70
AutoReps=3
)

IfNotExist, %A_ScriptDir%\Saved-Prompts.ini
	FileAppend, %DefaultFile%, %A_ScriptDir%\Saved-Prompts.ini

IniRead, SavedPrompts, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, MainList
IniRead, SavedPromptsP2, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, AutoList
IniRead, AutoPDelay, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, AutoDelay
IniRead, AutoPReps, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, AutoReps

Gui, Font, s13
Gui Add, Edit, x6 y3 w638 h84 vPrompt
Gui Add, Slider, x0 y111 w100 h29 Range-20-20 Tickinterval5 vSli1 gSmit, 7
Gui Add, Slider, x100 y111 w101 h29 Range1-50 Tickinterval5 vSli2 gSmit, 50
Gui Add, Slider, x200 y111 w100 h29 Range1-4 Tickinterval1 vSli3 gSmit, 4
Gui Add, Edit, x305 y119 w105 h28 hwndEdit2 vSeed,
EM_SETCUEBANNER(Edit2, "SEED")
Gui Add, Text, x10 y90 w188 h23 vCfg, CFG_S: 7
Gui Add, Text, x107 y90 w168 h23 vSTEPS, STEPS: 50
Gui Add, Text, x207 y90 w90 h23 vNum, IMAGES: 4
Gui Add, DropDownList, x305 y90 w105 vSamp, SAMPLER||k_euler|k_euler_ancestral|k_heun|k_dpm_2|k_dpm_2_ancestral|ddim|plms|
Gui Add, DropDownList, x474 y119 w68 vShortAspect gStarter, 1:1||16:9|9:16|16:10|2:3|4:3|4:5|1:2|2:1|
Gui Add, Edit, x412 y119 w60 h28 hwndEdit3 vCustomRes gCusRes
EM_SETCUEBANNER(Edit3, "RES")
Gui, Add, DropDownList, x544 y119 w100 vAspectRatiosFull, 64x64|128x128|192x192|256x256|320x320|384x384|448x448|512x512||576x576|640x640|704x704|768x768|832x832|896x896|960x960|1024x1024
Gui Add, Button, x411 y89 w78 h30 vSendP gSend, SEND
Gui Add, Button, x567 y89 w78 h30 vResetP gReset, RESET
Gui Add, Button, x489 y89 w78 h30 vCopy gCopy, COPY
Gui, Font, s9
Gui Add, Tab3, x0 y150 w652 h150 +Bottom , SAVED PROMPTS| AUTOMATIC PROMPTS |
Gui Add, ListBox, x4 y154 w541 h121 vSavedPromptsList gSelectSave, %SavedPrompts%
Gui Add, Button, x549 y157 w96 h23 gSave, ←SAVE
Gui Add, Button, x549 y180 w96 h23 gDeleteSave, ←DELETE
Gui Add, Text, x0 y274 w652 h2 +0x10
Gui Add, Text, x0 y154 w653 h2 +0x10
Gui Tab, 2
Gui Add, ListBox, x4 y154 w512 h121 gAutoList vAutoPromptList gAutoList, %SavedPromptsP2%
Gui Add, Button, x519 y248 w63 h23 gStartAuto, START
Gui Add, Button, x583 y248 w63 h23 gStopAuto, STOP
Gui Add, Button, x519 y158 w127 h23 gAddAuto, ADD
Gui Add, Text, x522 y190 w37 h23, DELAY:
Gui Add, Text, x522 y222 w45 h23, REPEAT:
Gui Add, Edit, x570 y219 w75 h21 +Number vAutoPReps gWriteReps,
Gui, Add, UpDown, Range1-9999, %AutoPReps%
Gui Add, Edit, x563 y188 w82 h21 +Number vAutoPDelay gWriteDelay, 
Gui, Add, UpDown, Range1-9999, %AutoPDelay%
Gui Add, Text, x0 y274 w653 h2 +0x10
Gui Add, Text, x0 y154 w653 h2 +0x10
Gui Show, w650 h300, Prompter

return

Smit:
{
	Gui, Submit, Nohide
	GuiControl,, Cfg, CFG_S: %Sli1%
	GuiControl,, Steps, STEPS: %Sli2%
	GuiControl,, Num, IMAGES: %Sli3%
	GuiControl,, Gui2Edit, %SavedPromptsAuto%
	GuiControl,, Gui2Edit2, %SavedPromptsAuto2%
	GuiControl,, AutoPromptList, |%SavedPromptsP2%|
	return
}

Send:
{
	Gosub, Copy
	IfWinExist, ahk_exe Discord.exe
	{
		WinGetTitle, titleDis, ahk_exe Discord.exe
		if InStr(titleDis, "dream")
		{
			WinActivate, ahk_exe Discord.exe
			IfWinActive, ahk_exe Discord.exe
			{
				Send {Escape}
				Sleep, 400
				Send, ^v
				Send, {Enter}
			}
		}
		else
		{
			MsgBox,,ERROR, Not in Dream channel (1-50)
		}
	}
	else
	{
		MsgBox,,ERROR, Discord not open
	}
	return
}

Reset:
{
	GuiControl,, Sli1, 7
	GuiControl,, Sli2, 50
	GuiControl,, Sli3, 4
	GuiControl,, Seed, 
	GuiControl,, CustomRes,
	GuiControl,, ShortAspect, |1:1||16:9|9:16|16:10|2:3|4:3|4:5|1:2|2:1|
	GuiControl,, AspectRatiosFull, |64x64|128x128|192x192|256x256|320x320|384x384|448x448|512x512||576x576|640x640|704x704|768x768|832x832|896x896|960x960|1024x1024
	GuiControl,, Samp, |SAMPLER||k_euler|k_euler_ancestral|k_heun|k_dpm_2|k_dpm_2_ancestral|ddim|plms|
	GuiControl,, Prompt, 
	return	
}

CusRes:
{
	CusResCounter := 1	
	Gosub, Starter
	return
}

Starter:
{
	Gui, Submit,Nohide
	64NumInc := 64
	BigSmallNumCounter := 0
	ListDisplayCounter := 0
	ListRes := 
	RatioDiv := 
	RoundNum2 :=
	Small :=
	Big :=
	Gui, Submit,Nohide
	if CusResCounter = 1
	{
		CusResCounter := 0
		SplitNumArray := StrSplit(CustomRes,":")
		if SplitNumArray[1] > 0 and SplitNumArray[2] > 0
		{
			GuiControl,, ShortAspect,<||
			if SplitNumArray[1] > SplitNumArray[2]
			{
				Big := SplitNumArray[1] 
				Small := SplitNumArray[2]
				BigSmallNumCounter := 1
				Gosub, ARUnder1MP
			}
			else
			{
				Big := SplitNumArray[1] 
				Small := SplitNumArray[2]
				BigSmallNumCounter := 0
				Gosub, ARUnder1MP
			}
		}
		else
		{
			return
		}
	}
	else
	{
		SplitNumArray := StrSplit(ShortAspect,":")
		if SplitNumArray[1] > SplitNumArray[2]
		{
			Big := SplitNumArray[1] 
			Small := SplitNumArray[2]
			BigSmallNumCounter := 1
			Gosub, ARUnder1MP
		}
		else
		{
			Big := SplitNumArray[1] 
			Small := SplitNumArray[2]
			BigSmallNumCounter := 0
			Gosub, ARUnder1MP
		}
	}
	return
}
	
ARUnder1MP:
{
	Gui, Submit,Nohide
	Loop,
	{
		if 64NumInc+RatioDiv > 2048
		{
			GuiControl,, AspectRatiosFull,|%ListRes%
			Break
		}
		if BigSmallNumCounter = 1
		{
			RatioDiv := 64NumInc/(Big/Small) 
		}
		else
		{
			RatioDiv := 64NumInc*(Small/Big) 
		}
		RoundNum2 := Ceil(RatioDiv)
		if ListDisplayCounter = 0
		{
			ListRes := ListRes . 64NumInc "x" RoundNum2 "||"
			ListDisplayCounter := 1
		}
		else
		{
			ListRes := ListRes . 64NumInc "x" RoundNum2 "|"
		}
		64NumInc += 64
	}
	return
}

Copy:
{
	Gui, Submit,Nohide
	
	if AutoStartCopy = 1
	{
		Prompt := CurrentArrayN
	}
	
	if Prompt = 
	{
		
	}
	else
	{
		FinalPrompt = -C %Sli1% -s %Sli2% -n %Sli3%
		if Seed = 
		{
			
		}
		else
		{
			FinalPrompt = %FinalPrompt% -S %Seed%
		}
		if Samp = SAMPLER
		{
			
		}
		else
		{
			FinalPrompt = %FinalPrompt% -A %Samp%
		}
		SplitFinal := StrSplit(AspectRatiosFull,"x")
		FinalPrompt := FinalPrompt " -W " SplitFinal[1] " -H " SplitFinal[2]
		clipboard := "!dream" " " """" Prompt """" " " FinalPrompt
	}
	return
}

Save:
{
	Gui, Submit,Nohide
	if Prompt = 
	{
		
	}
	else
	{
		SavedPrompts := SavedPrompts . Prompt "|"
		GuiControl,, SavedPromptsList, |%SavedPrompts%|
		IniWrite, %SavedPrompts%, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, MainList
	}
	return
}

SelectSave:
{
	Gui, Submit,NoHide
	GuiControl,, Prompt, %SavedPromptsList%
	return
}

DeleteSave:
{
	Gui, Submit,Nohide
	SavedPrompts := StrReplace(SavedPrompts, SavedPromptsList "|" , "",,1)
	GuiControl,, SavedPromptsList, |%SavedPrompts%|
	IniWrite, %SavedPrompts%, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, MainList
	return
}

AddAuto:
{
	if WinExist("Add Prompt")
	{
		MsgBox, 4096,ERROR, Close Add window before opening new
	}
	else
	{
		Gui 2:Add, ListBox, x5 y0 w200 h150 vSavedPromptsAuto gSmit, %SavedPrompts%
		Gui 2:Add, Edit, x209 y0 h116 w385 vGui2Edit
		Gui 2:Add, Button, x208 y120 h28 w387 gGui2Add, ADD
		Gui 2: +AlwaysOnTop
		Gui 2:Show, h153 w600, Add Prompt
	}
	return
}

DeleteAuto:
{
	if AutoStartCopy = 1
	{
		MsgBox, 4096,ERROR, Cannot delete prompt while AutoPrompt is running
		Gui 3:Destroy
	}
	else
	{
		Gui, Submit, Nohide
		Gui 3:Destroy	
		SavedPromptsP2 := StrReplace(SavedPromptsP2, AutoPromptList "|" , "",,1)
		IniWrite, %SavedPromptsP2%, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, AutoList
		UpdateGui()
	}
	return
}

StopAuto:
{
	StopA := 1
	AutoStartCopy := 0
	return
}

StartAuto:
{
	AutoStartCopy := 1
	AutoPCounter := 0
	Gui, Submit,Nohide
	AutoPDelayX1k := AutoPDelay*1000
	StrReplace(SavedPromptsP2, "|", "|", NumOfPrompts)
	PromptArray := StrSplit(SavedPromptsP2, "|", "|")
	if NumOfPrompts = 0
	{
		
	}
	else
	{
		Loop, %NumOfPrompts%
		{
			
			AutoPCounter += 1
			CurrentArrayN := PromptArray[AutoPCounter]
			
			if StopA = 1
			{
				StopA := 0
				Break
			}
			Loop, %AutoPReps%
			{
				Gosub, Send
				Sleep, %AutoPDelayX1k%
			}
			
		}
		AutoStartCopy := 0
	}
	return
}

Gui2Add:
{
	Gui 2:Submit
	if Gui2Edit = 
	{
	Gui 2:Destroy	
	}
	else
	{
	Gui 2:Destroy
	SavedPromptsP2 := SavedPromptsP2 . Gui2Edit "|"
	UpdateGui()
	IniWrite, %SavedPromptsP2%, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, AutoList
	}
	return
}

AutoList:
{
	if WinExist("Add Prompt")
	{
		MsgBox, 4096,ERROR, Close Edit window before opening new
	}
	else
	{
		Gui, Submit, NoHide
		Gui 3:Add, ListBox, x5 y0 w200 h150 vSavedPromptsAuto2 gSmit, %SavedPrompts%
		Gui 3:Add, Edit, x209 y0 h116 w385 vGui2Edit2
		Gui 3:Add, Button, x208 y120 h28 w193 gGui2EditSave, UPDATE
		Gui 3:Add, Button, x402 y120 h28 w193 gDeleteAuto, DELETE
		Gui 3: +AlwaysOnTop
		Gui 3:Show, h153 w600, Add Prompt
	}
	
	return
}

Gui2EditSave:
{
	Gui, Submit, NoHide
	if Gui2Edit2 = 
	{
		Gui 3:Destroy	
	}
	else
	{
		Gui 3:Destroy
		SavedPromptsP2 := StrReplace(SavedPromptsP2, AutoPromptList "|", Gui2Edit2 "|",,1)
		PromptArray := StrSplit(SavedPromptsP2, "|", "|")
		CurrentArrayN := PromptArray[AutoPCounter]
		UpdateGui()
		IniWrite, %SavedPromptsP2%, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, AutoList
	}
}

WriteDelay:
{
	Gui, Submit,Nohide
	IniWrite, %AutoPDelay%, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, AutoDelay
	return
}

WriteReps:
{
	Gui,Submit,Nohide
	IniWrite, %AutoPReps%, %A_ScriptDir%\Saved-Prompts.ini, SavedSection, AutoReps
	return
}

3GuiClose:
{
	Gui 3:Destroy
	return
}

2GuiClose:
{
	Gui 2:Destroy
	return
}

GuiClose:
{
	ExitApp
	return
}

EM_SETCUEBANNER(hWnd, Cue)
{
	return DllCall("user32.dll\SendMessage", "Ptr", hWnd, "UInt", 0x1501, "Ptr", 1, "Ptr", &Cue, "Ptr")
}

UpdateGui()
{
	SetTimer, Smit, On
	Sleep, 1000
	SetTimer, Smit, Off
}

;dapooper#5601
#IfWinActive, Prompter
Up::return
Down::return
return
